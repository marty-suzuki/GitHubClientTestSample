//
//  GitHub.Session.swift
//  GitHubClientTestSample
//
//  Created by 鈴木大貴 on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation
import RxSwift

extension GitHub {

    final class Session {

        private let additionalHeaderFields: () -> [String: String]?
        private let session: URLSession

        init(additionalHeaderFields: @escaping () -> [String: String]? = { nil },
                    session: URLSession = .shared) {
            self.additionalHeaderFields = additionalHeaderFields
            self.session = session
        }
    }
    
    enum SessionError: Error {
        case noData(HTTPURLResponse)
        case noResponse
        case failedToCreateComponents(URL)
        case failedToCreateURL(URLComponents)
    }
}

extension GitHub.Session {
    typealias Pagination = GitHub.Pagination
    typealias SessionError = GitHub.SessionError
    typealias Response<T: GitHubRequest> = Either<(T.Response, Pagination), Error>

    @discardableResult
    func send<T: GitHubRequest>(_ request: T) -> Observable<Response<T>> {
        let url = request.baseURL.appendingPathComponent(request.path)

        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return Observable<Response<T>>.just(.right(SessionError.failedToCreateComponents(url)))
        }
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)

        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            return Observable<Response<T>>.just(.right(SessionError.failedToCreateURL(componets)))
        }

        urlRequest.httpMethod = request.method.rawValue

        let headerFields: [String: String]
        if let additionalHeaderFields = additionalHeaderFields() {
            headerFields = request.headerFields.merging(additionalHeaderFields, uniquingKeysWith: +)
        } else {
            headerFields = request.headerFields
        }

        urlRequest.allHTTPHeaderFields = headerFields

        return Observable<Response<T>>.create { [session] observer in
            let task = session.dataTask(with: urlRequest) { data, response, error in
                defer {
                    observer.onCompleted()
                }

                if let error = error {
                    observer.onNext(.right(error))
                    return
                }

                guard let resposne = response as? HTTPURLResponse else {
                    observer.onNext(.right(SessionError.noResponse))
                    return
                }

                guard let data = data else {
                    observer.onNext(.right(SessionError.noData(resposne)))
                    return
                }

                let pagination: Pagination
                if let link = resposne.allHeaderFields["Link"] as? String {
                    pagination = Pagination(link: link)
                } else {
                    pagination = Pagination(next: nil, last: nil, first: nil, prev: nil)
                }

                do {
                    let object = try JSONDecoder().decode(T.Response.self, from: data)
                    observer.onNext(.left((object, pagination)))
                } catch {
                    observer.onNext(.right(error))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
        .take(1)
    }
}
