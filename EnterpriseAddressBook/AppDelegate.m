//
//  AppDelegate.m
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsViewController.h"
#import "DialViewController.h"
#import "EnterpriseNameViewController.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
  [_window release];
  [_tabBarController release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  UITabBarItem *dialTab = [[UITabBarItem alloc] initWithTitle:@"拨号" image:nil tag:0];
  UITabBarItem *contactTab = [[UITabBarItem alloc] initWithTitle:@"联系人" image:nil tag:1];
  UITabBarItem *enterpriseTab = [[UITabBarItem alloc] initWithTitle:@"企业圈" image:nil tag:2];  
  
  // Override point for customization after application launch.
  UIViewController *contactsViewController = [[[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil] autorelease];
  
  UIViewController *dialViewController = [[[DialViewController alloc] initWithNibName:@"DialViewController" bundle:nil] autorelease];
  UIViewController *enterpriseNameViewController = [[EnterpriseNameViewController alloc] initWithNibName:@"EnterpriseNameViewController" bundle:nil];
  
  
  UINavigationController *aNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:dialViewController] autorelease];
  UINavigationController *aNavigationController2 = [[[UINavigationController alloc] initWithRootViewController:contactsViewController] autorelease];
  UINavigationController *aNavigationController3 = [[[UINavigationController alloc] initWithRootViewController:enterpriseNameViewController] autorelease];
  [contactsViewController.navigationItem setTitle: @"通话记录"];
  [dialViewController.navigationItem setTitle: @"联系人"];
  [enterpriseNameViewController.navigationItem setTitle: @"企业圈"];
  aNavigationController1.tabBarItem = dialTab;
  aNavigationController2.tabBarItem = contactTab;
  aNavigationController3.tabBarItem = enterpriseTab;
  [aNavigationController1.navigationBar setTintColor:[UIColor colorWithRed:0xcc/255.0 green:0x33/255.0 blue:0.f/255.0 alpha:1.0]];
  
  [aNavigationController2.navigationBar setTintColor:[UIColor colorWithRed:0xcc/255.0 green:0x33/255.0 blue:0.f/255.0 alpha:1.0]];
  [aNavigationController3.navigationBar setTintColor:[UIColor colorWithRed:0xcc/255.0 green:0x33/255.0 blue:0.f/255.0 alpha:1.0]];
  self.tabBarController = [[[MainViewController alloc] init] autorelease];
  
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:aNavigationController1, aNavigationController2, aNavigationController3, nil];
  
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

@end
