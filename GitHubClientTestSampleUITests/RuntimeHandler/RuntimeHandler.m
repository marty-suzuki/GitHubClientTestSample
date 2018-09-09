//
//  RuntimeHandler.m
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

#import "RuntimeHandler.h"

@implementation _RuntimeHandler

+ (void)handleLoad {
    NSLog(@"Please override RuntimeHandler.handleLoad if you want to use");
}

+ (void)handleInitialize {
    NSLog(@"Please override RuntimeHandler.handleInitialize if you want to use");
}

@end

@implementation RuntimeHandler

+ (void)initialize {
    [super initialize];
    [self handleInitialize];
}

+ (void)load {
    [super load];
    [self handleLoad];
}

@end
