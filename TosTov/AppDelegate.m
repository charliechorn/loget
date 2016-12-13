//
//  AppDelegate.m
//  TosTov
//
//  Created by Pichzz on 11/2/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "MainViewController.h"
#import "TabBarViewController.h"
#import "SignUpViewController.h"
@import GoogleMaps;
@import GoogleMapsBase;

@interface AppDelegate ()

@property (nonatomic, strong) MainViewController *mainView;
@property (nonatomic, strong) LogInViewController *loginView;
@property (nonatomic, strong) TabBarViewController *tabBarController;
@property (nonatomic, strong) SignUpViewController *signUpView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [GMSServices provideAPIKey:@"AIzaSyBq06TlMr5s89Zxb084iHwusHkLhNRLiMQ"];
    //[GMSPlacesClient provideAPIKey:@"AIzaSyBq06TlMr5s89Zxb084iHwusHkLhNRLiMQ"];
    
                                    /** UserName/password default **/
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setObject:@"12345" forKey:@"phonenum"];
    [standardUserDefault setObject:@"test" forKey:@"passwd"];
    [standardUserDefault setObject:@"0" forKey:@"isChangePassword"];
    [standardUserDefault synchronize];
    
                                    /** Add observers **/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMain) name:@"NofMain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLogin) name:@"NofLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSignUp) name:@"NofSignUp" object:nil];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[LogInViewController alloc]init];
    self.loginView.view.frame = [[UIScreen mainScreen] bounds];
    self.window.rootViewController = self.loginView;
    
    
    /**
    self.tabBarController = [[TabBarViewController alloc]init];
    self.tabBarController.view.frame= [[UIScreen mainScreen]bounds];
    self.window.rootViewController = self.tabBarController;
    **/
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

                                        /** Custom function **/
-(void)gotoMain{
    self.signUpView = nil;

    self.window.rootViewController = nil;
    //self.mainView = [[MainViewController alloc]init];
    //self.mainView.view.frame = [[UIScreen mainScreen] bounds];
    //self.window.rootViewController = self.mainView;
    //self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [[TabBarViewController alloc]init];
    self.tabBarController.view.frame= [[UIScreen mainScreen]bounds];
    
    self.tabBarController.tabBar.barTintColor = [UIColor blackColor];
    //[self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"]];


    self.window.rootViewController = self.tabBarController;
}

-(void)gotoLogin{
    self.window.rootViewController = nil;
    self.loginView = [[LogInViewController alloc]init];
    self.loginView.view.frame = [[UIScreen mainScreen]bounds];
    self.window.rootViewController = self.loginView;
}

-(void)gotoSignUp{
    self.window.rootViewController = nil;
    self.signUpView = [[SignUpViewController alloc]init];
    self.signUpView.view.frame = [[UIScreen mainScreen]bounds];
    self.window.rootViewController = self.signUpView;
}

@end
