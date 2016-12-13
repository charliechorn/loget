//
//  SearchDriverViewController.m
//  TosTov
//
//  Created by Pichzz on 11/11/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "SearchDriverViewController.h"

@interface SearchDriverViewController ()

@property (nonatomic, strong) UIButton *btnRefresh;
@property (nonatomic, strong) UIButton *btnClose;

@end

@implementation SearchDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
}

                                        /** Functionality **/
// Go back to previous view
-(void)backToMain{
    [self dismissViewControllerAnimated:true completion:nil];
}


                                        /** View decoration **/

-(void)addComponents {
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    
    // add label title Tos Tov
//    UILabel *lblTosTov = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135) / 2 , 60, 135, 50)];
//    lblTosTov.textColor = [UIColor whiteColor];
//    lblTosTov.text = @"TOS @ TOV";
//    lblTosTov.font = [UIFont systemFontOfSize:25];
//    //lblTosTov.layer.borderWidth = 1;
//    //lblTosTov.layer.borderColor = [UIColor redColor].CGColor;
//    [self.view addSubview:lblTosTov];
    
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 60, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add search logo
    UIImageView *searchLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SearchIcon.png"]];
    searchLogo.frame = CGRectMake((self.view.bounds.size.width-150)/2,
                                  tosTovLogo.frame.origin.y + tosTovLogo.bounds.size.height + 50, 150, 148);
    //searchLogo.layer.borderColor = [UIColor redColor].CGColor;
    //searchLogo.layer.borderWidth = 1;
    [self.view addSubview:searchLogo];
    
    
    // add label please wait
    UILabel *lblPleaseWait = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-140)/2,
                                                                     searchLogo.frame.origin.y + searchLogo.bounds.size.height + 50,
                                                                     140, 25)];
    lblPleaseWait.font = [UIFont systemFontOfSize:20];
    lblPleaseWait.textColor = [UIColor greenColor];
    //lblPleaseWait.layer.borderWidth = 1;
    //lblPleaseWait.layer.borderColor = [UIColor redColor].CGColor;
    lblPleaseWait.text = @"PLEASE WAIT...";
    [self.view addSubview:lblPleaseWait];
    
    // add label search driver
    NSString *searchDriverStr = @"SEARCHING FOR DRIVERS NEAREST TO YOU";
    CGFloat searchDriverWidth = [searchDriverStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblSearchDriver = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - searchDriverWidth) / 2,
                                                                        lblPleaseWait.frame.origin.y + lblPleaseWait.bounds.size.height+5, searchDriverWidth, 10)];
    lblSearchDriver.font = [UIFont systemFontOfSize:12];
    lblSearchDriver.textColor = [UIColor whiteColor];
    lblSearchDriver.text = searchDriverStr;
    [self.view addSubview:lblSearchDriver];
    
    // add button refresh
    self.btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRefresh.frame = CGRectMake(0, self.view.bounds.size.height - 40 - 64, self.view.bounds.size.width / 2, 40);
    UIImage *buttonImageRefresh = [UIImage imageNamed:@"RefreshButton.png"];
    self.btnRefresh.backgroundColor = [UIColor greenColor];
    self.btnRefresh.layer.borderColor = [UIColor greenColor].CGColor;
    [self.btnRefresh setImage:buttonImageRefresh forState:UIControlStateNormal];
    [self.view addSubview:self.btnRefresh];
    
    // add button close
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClose.frame = CGRectMake(self.view.bounds.size.width / 2, self.btnRefresh.frame.origin.y, self.view.bounds.size.width / 2, 40);
    UIImage *buttonImageCancel = [UIImage imageNamed:@"CancelButton.png"];
    self.btnClose.backgroundColor = [UIColor redColor];
    self.btnClose.layer.borderColor = [UIColor redColor].CGColor;
    [self.btnClose setImage:buttonImageCancel forState:UIControlStateNormal];
    [self.view addSubview:self.btnClose];
    
}


@end
