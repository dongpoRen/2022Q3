//
//  AppDelegate.m
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/1.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ContainerViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
