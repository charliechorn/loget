//
//  HomeViewController.m
//  TosTov
//
//  Created by Charlie on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "HomeViewController.h"
#import "TosTovViewController.h"
#import "TosTovTripViewController.h"
#import "TosSendDetailViewController.h"



@interface HomeViewController ()
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UIImageView *imgTosTov;
@property (nonatomic, strong) UIImageView *imgTosSend;
@property (nonatomic, strong) UIImageView *imgTovFood;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
    
}

                                    /** Functionality **/
// Go to Tos Tov view
-(void)tapOnTosTov{
//    TosTovViewController *tosTovVC= [[TosTovViewController alloc]init];
//    tosTovVC.view.frame = self.view.bounds;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tosTovVC];
//    nav.navigationBar.barTintColor = [UIColor grayColor];
//    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
//    nav.navigationBar.translucent = NO;
//    [self presentViewController:nav animated:true completion:nil];
    
    TosTovTripViewController *tosTovVC = [[TosTovTripViewController alloc]init];
    tosTovVC.view.frame = self.view.bounds;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tosTovVC];
    nav.navigationBar.barTintColor = [UIColor grayColor];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:true completion:nil];
}

// Go to Tos Send view
-(void)tapOnTosSend{
    TosSendDetailViewController *tosSendVC = [[TosSendDetailViewController alloc]init];
    tosSendVC.view.frame =self.view.bounds;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tosSendVC];
    nav.navigationBar.barTintColor = [UIColor grayColor];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:true completion:nil];

}



                                    /** View decoration **/
-(void)addComponents{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *navLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    navLogo.frame = CGRectMake(0, 0, 180, 30);
    [navLogo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = navLogo;

    
    
    // add Wing logo
    UIImageView *winglogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WingLogo.png"]];
    winglogo.frame = CGRectMake(5, 3, 35, 20);
    [self.view addSubview:winglogo];
    
    
    // add amount money
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, 5, 55, 15)];
    amountLabel.text = @"0.00 USD";
    amountLabel.textColor = [UIColor redColor];
    amountLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:amountLabel];
    
    // add cover image
    self.coverImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HomeCoverIcon1.png"]];
    if (IS_IPHONE_5) {
        self.coverImage.frame = CGRectMake(0, 25, self.view.bounds.size.width, 110);
    }
    else{
        self.coverImage.frame = CGRectMake(0, 25, self.view.bounds.size.width, 135);
    }
    
    [self.view addSubview:self.coverImage];
    
    // add image Tos Tov
    self.imgTosTov = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovHomeIcon1.png"]];
    if (IS_IPHONE_5) {
        self.imgTosTov.frame = CGRectMake(0,
                                          self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                          self.view.bounds.size.width/3,
                                          90);
    }
    else{
        self.imgTosTov.frame = CGRectMake(0,
                                          self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                          self.view.bounds.size.width/3,
                                          110);
    }
    self.imgTosTov.layer.borderColor = [UIColor grayColor].CGColor;
    self.imgTosTov.layer.borderWidth = 1;
    self.imgTosTov.contentMode = UIViewContentModeScaleAspectFit;
    // add gesture tap to imgTosTov
    UITapGestureRecognizer *tapTosTov = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTosTov)];
    tapTosTov.numberOfTapsRequired = 1;
    self.imgTosTov.userInteractionEnabled = YES;
    [self.imgTosTov addGestureRecognizer:tapTosTov];
    [self.view addSubview:self.imgTosTov];
    
    // add image Tos Send
    self.imgTosSend = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovHomeIcon2.png"]];
    if (IS_IPHONE_5) {
        self.imgTosSend.frame = CGRectMake(self.imgTosTov.bounds.size.width,
                                           self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                           self.view.bounds.size.width/3,
                                           90);
    }
    else{
        self.imgTosSend.frame = CGRectMake(self.imgTosTov.bounds.size.width,
                                           self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                           self.view.bounds.size.width/3,
                                           110);
    }
    
    self.imgTosSend.layer.borderColor = [UIColor grayColor].CGColor;
    self.imgTosSend.layer.borderWidth = 1;
    self.imgTosSend.contentMode = UIViewContentModeScaleAspectFit;
    // add gesture tap to imgTosSend
    UITapGestureRecognizer *tapTosSend = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTosSend)];
    tapTosSend.numberOfTapsRequired = 1;
    self.imgTosSend.userInteractionEnabled = YES;
    [self.imgTosSend addGestureRecognizer:tapTosSend];
    [self.view addSubview:self.imgTosSend];
    
    // add img Tov Food
    self.imgTovFood = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovHomeIcon3.png"]];
    if (IS_IPHONE_5) {
        self.imgTovFood.frame = CGRectMake(self.imgTosSend.bounds.size.width + self.imgTosTov.bounds.size.width,
                                           self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                           self.view.bounds.size.width/3,
                                           90);
    }
    else {
        self.imgTovFood.frame = CGRectMake(self.imgTosSend.bounds.size.width + self.imgTosTov.bounds.size.width,
                                           self.coverImage.frame.origin.y + self.coverImage.frame.size.height,
                                           self.view.bounds.size.width/3,
                                           110);
    }
    
    self.imgTovFood.layer.borderColor = [UIColor grayColor].CGColor;
    self.imgTovFood.layer.borderWidth = 1;
    self.imgTovFood.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imgTovFood];
}

@end
