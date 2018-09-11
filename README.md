# GitHubClientTestSample

A GitHub client sample for User Action Logs testing.

- [x] UITest
- [x] UnitTest

![UITest](./Images/uitest.gif)

# Usage

First of all, you should execute a following command to install dependencies.

```
$ make install
```

Next, open **GitHubClientTestSample.xcworkspace** and run an application.

# Requirements

- Xcode 9.4.1
- Swift 4.1
- Carthage 0.27.0
- CocoaPods 1.5.3
- [RxSwift](https://github.com/ReactiveX/RxSwift) 4.2.0
- [KIF](https://github.com/kif-framework/KIF) v3.7.4
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery) 0.14.0

# Multiple testing with [bluepill](https://github.com/linkedin/bluepill)

![bluepill](./Images/bluepill.gif)

```
$ make install-bluepill
$ make ui-testing
```

# Author

Taiki Suzuki, s1180183@gmail.com

# License

GitHubClientTestSample is available under the MIT license. See the LICENSE file for more info.
