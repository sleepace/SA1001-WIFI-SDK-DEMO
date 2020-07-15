//
//  AppDelegate.m
//  SA1001-Demo
//
//  Created by jie yang on 2019/8/5.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

@interface AppDelegate ()
{

}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    UIViewController *rootViewController = [MainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [nav setNavigationBarHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
