//
//  AppDelegate.m
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    MainController *mainVC = [[MainController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
