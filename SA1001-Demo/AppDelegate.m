//
//  AppDelegate.m
//  SA1001-Demo
//
//  Created by jie yang on 2019/8/5.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

#import <SLPMLan/SLPMLan.h>

@interface AppDelegate ()
{
    NetWorkTool *_conn;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self startMonitorNetwork];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    UIViewController *rootViewController = [MainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [nav setNavigationBarHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)startMonitorNetwork
{
    _conn = [NetWorkTool reachabilityForInternetConnection];
    [_conn startNotifier];
}

@end
