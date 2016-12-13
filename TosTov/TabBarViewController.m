//
//  TabBarViewController.m
//  TosTov
//
//  Created by Charlie on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "HelpViewController.h"
#import "MyAccountViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self setupView];
    }

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    // Home tab
    HomeViewController *homeViewController = [[HomeViewController alloc]init];
    homeViewController.view.frame = self.view.bounds;
    //homeViewController.title = @"Home";
    UINavigationController *homeNavController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    
    [homeNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    homeNavController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    homeNavController.navigationBar.translucent = false;
    UIImage *homeSelected = [UIImage imageNamed:@"HomeSelectedIcon.png"];
    UIImage *home = [UIImage imageNamed:@"HomeIcon.png"];
    homeNavController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:[home imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[homeSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNavController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
    
    // History tab
    HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
    historyViewController.view.frame = self.view.bounds;
    historyViewController.title = @"History";
    UINavigationController *historyNavController = [[UINavigationController alloc]initWithRootViewController:historyViewController];
    [historyNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    historyNavController.navigationBar.translucent = false;
    UIImage *historySelected = [UIImage imageNamed:@"HistorySelectedIcon.png"];
    UIImage *history = [UIImage imageNamed:@"HistoryIcon.png"];
    historyNavController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"History" image:[history imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[historySelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [historyNavController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
    
    
    // Help tab
    HelpViewController *helpViewController = [[HelpViewController alloc]init];
    helpViewController.view.frame = self.view.bounds;
    helpViewController.title = @"Help";
    UINavigationController *helpNavController = [[UINavigationController alloc]initWithRootViewController:helpViewController];
    [helpNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    helpNavController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    helpNavController.navigationBar.translucent = false;
    UIImage *helpSelected = [UIImage imageNamed:@"HelpSelectedIcon.png"];
    UIImage *help = [UIImage imageNamed:@"HelpIcon.png"];
    helpNavController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Help" image:[help imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[helpSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [helpNavController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];

    
    // My Account tab
    MyAccountViewController *myaccViewController = [[MyAccountViewController alloc]init];
    myaccViewController.view.frame = self.view.bounds;
    myaccViewController.title = @"My Account";
    UINavigationController *myaccNavController = [[UINavigationController alloc]initWithRootViewController:myaccViewController];
    [myaccNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    myaccNavController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    myaccNavController.navigationBar.translucent = false;
    UIImage *myAccSelected = [UIImage imageNamed:@"MyAccSelectedIcon.png"];
    UIImage *myAcc = [UIImage imageNamed:@"MyAccIcon.png"];
    myaccNavController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"My Account" image:[myAcc imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[myAccSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [myaccNavController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];

    
    
    
    
    //[[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"HomeIconSelected.png"]];
    //[[self.tabBarController.tabBar.items objectAtIndex:1]setTitle:@"History"];
    //[[self.tabBarController.tabBar.items objectAtIndex:2]setTitle:@"Help"];
    //[[self.tabBarController.tabBar.items objectAtIndex:3]setTitle:@"My Account"];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:homeNavController,historyNavController,helpNavController, myaccNavController,nil];
    

}



@end
