//
//  ProgressTripViewController.m
//  TosTov
//
//  Created by Charlie on 11/11/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ProgressTripViewController.h"
#import "SearchDriverViewController.h"

@interface ProgressTripViewController ()

@property (nonatomic, strong) UITextField *txtOrigin;
@property (nonatomic, strong) UITextField *txtDesc;
//@property (nonatomic, strong) MKMapView *tripMap;
@property (nonatomic, strong) GMSMapView *mapView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnMessage;
@property (nonatomic, strong) UIButton *btnCall;

@end

@implementation ProgressTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addComponents];
}

                                        /** Functionality **/

// Constructor to init with trip content
-(id)initWithData:(NSDictionary *)data{
    if(self=[super init]){
        self.tripContent=data;
    }
    return self;
}

// Go back to previous view
-(void)backToMain{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)refreshMap{
    
}

/** View Decoration **/
-(void)addComponents{
    
    self.title = @"TOS TOV";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    // add refresh button
    UIImage *refreshIcon = [[UIImage imageNamed:@"RefreshIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barRefreshButtonItem = [[UIBarButtonItem alloc] initWithImage:refreshIcon style:UIBarButtonItemStylePlain target:self action:@selector(refreshMap)];
    self.navigationItem.rightBarButtonItem = barRefreshButtonItem;
    
    // add place icon
    UIImageView *routeLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlaceIcon.png"]];
    routeLogo.frame = CGRectMake(10, 10, 15 ,60);
    routeLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:routeLogo];
    
    // add logo origin
//    UIImageView *originLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedMap.png"]];
//    originLogo.frame = CGRectMake(5,10,30,30);
//    originLogo.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:originLogo];
    
    // add textfield origin
    self.txtOrigin = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                  routeLogo.frame.origin.y,
                                                                  self.view.bounds.size.width - 50,30)];
    self.txtOrigin.borderStyle = UITextBorderStyleNone;
    self.txtOrigin.text = @"Brown Coffe Roastery";
    [self.txtOrigin setEnabled:FALSE];
    [self.view addSubview:self.txtOrigin];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.txtOrigin.frame.origin.x,
                                                           self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 2,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    // add logo destination
//    UIImageView *desLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedMap.png"]];
//    desLogo.frame = CGRectMake(5,originLogo.frame.origin.y + originLogo.bounds.size.height + 5,30,30);
//    desLogo.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:desLogo];
    
    // add textfield destination
    self.txtDesc = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 5,
                                                                self.view.bounds.size.width - 50,30)];
    self.txtDesc.borderStyle = UITextBorderStyleNone;
    self.txtDesc.text = [self.tripContent objectForKey:@"place"];
    [self.txtDesc setEnabled:FALSE];
    [self.view addSubview:self.txtDesc];
    
    // add map
//    self.tripMap = [[MKMapView alloc]initWithFrame:CGRectMake(0, routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5,
//                                                              self.view.bounds.size.width,
//                                                              self.view.bounds.size.height - (routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5))];
//    [self.view addSubview:self.tripMap];
    
    // add map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:11.562108 longitude:104.888535 zoom:14];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.frame = CGRectMake(0, routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5,
                                    self.view.bounds.size.width,
                                    self.view.bounds.size.height - (routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5));
    
    [self.view addSubview:self.mapView];
    
    // add footer view
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 130 - 67, /** 67 is additional **/
                                                              self.view.bounds.size.width - 6, 130)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    // add label distance
    UILabel *lblDistance = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, self.view.bounds.size.width / 3, 10)];
    lblDistance.font = [UIFont systemFontOfSize:12];
    lblDistance.text = @"Distance (2.2 km)";
    [self.footerView addSubview:lblDistance];
    
    // add label price
    NSString *priceStr = @"Price 8000R";
    CGFloat priceWidth = [priceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.footerView.bounds.size.width - (priceWidth), 5,
                                                                 priceWidth, 10)];
    lblPrice.font = [UIFont systemFontOfSize:12];
    lblPrice.textColor = [UIColor redColor];
    lblPrice.text = priceStr;
    [self.footerView addSubview:lblPrice];
    
    // add line 1
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(2, 18, self.footerView.bounds.size.width-4, 1)];
    line1.backgroundColor = [UIColor blackColor];
    [self.footerView addSubview:line1];
    
    // add driver image
    UIImageView *driverImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DriverIcon.png"]];
    driverImage.frame = CGRectMake(15,line1.frame.origin.y + 6, 70, 70);
    [self.footerView addSubview:driverImage];
    
    // add line 2
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(driverImage.frame.origin.x + driverImage.bounds.size.width+15,
                                                            driverImage.frame.origin.y, 1, driverImage.bounds.size.height)];
    line2.backgroundColor = [UIColor blackColor];
    [self.footerView addSubview:line2];
    
    // add lable driver name
    NSString *driverNameStr = @"Driver Name";
    CGFloat driverNameWidth = [driverNameStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblDriverName = [[UILabel alloc]initWithFrame:CGRectMake(line2.frame.origin.x + 15,
                                                                      driverImage.frame.origin.y + 5,
                                                                      driverNameWidth, 15)];
    lblDriverName.font = [UIFont systemFontOfSize:12];
    lblDriverName.text = driverNameStr;
    [self.footerView addSubview:lblDriverName];
    
    // add order number label
    NSString *orderNumStr = @"Order No: 888777999";
    CGFloat orderNumWidth = [orderNumStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(lblDriverName.frame.origin.x,
                                                                    lblDriverName.frame.origin.y + lblDriverName.bounds.size.height + 10,
                                                                    orderNumWidth, 15)];
    lblOrderNum.font = [UIFont systemFontOfSize:12];
    lblOrderNum.text = orderNumStr;
    [self.footerView addSubview:lblOrderNum];
    
    // add lable status
    NSString *statusStr = @"Arriving in 5 mn";
    CGFloat statusWidth = [statusStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(lblDriverName.frame.origin.x,
                                                                  lblOrderNum.frame.origin.y + lblOrderNum.bounds.size.height + 10,
                                                                  statusWidth, 15)];
    lblStatus.font = [UIFont systemFontOfSize:12];
    lblStatus.textColor = [UIColor greenColor];
    lblStatus.text = statusStr;
    [self.footerView addSubview:lblStatus];
    
    
    // add line 3
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(line1.frame.origin.x,
                                                            driverImage.frame.origin.y + driverImage.bounds.size.height + 5,
                                                            line1.bounds.size.width, 1)];
    line3.backgroundColor = [UIColor blackColor];
    [self.footerView addSubview:line3];
    
    // add need help
    UIView *viewAction = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               line3.frame.origin.y + 2, self.footerView.bounds.size.width, 30)];
    //needHelp.layer.borderColor = [UIColor redColor].CGColor;
    //needHelp.layer.borderWidth = 1;
    [self.footerView addSubview:viewAction];
    
    // add cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(viewAction.bounds.size.width / 8, 2, 26, 26);
    [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"CancelIcon.png"] forState:UIControlStateNormal];
    [viewAction addSubview:self.btnCancel];
    
    // add message button
    self.btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMessage.frame = CGRectMake((viewAction.bounds.size.width - 26) / 2, 2, 26, 26);
    [self.btnMessage setBackgroundImage:[UIImage imageNamed:@"MessageIcon.png"] forState:UIControlStateNormal];
    [viewAction addSubview:self.btnMessage];
    
    // add call button
    self.btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCall.frame = CGRectMake(viewAction.bounds.size.width - (viewAction.bounds.size.width / 8) - 26,
                                    2, 26, 26);
    [self.btnCall setBackgroundImage:[UIImage imageNamed:@"CallIcon.png"] forState:UIControlStateNormal];
    [viewAction addSubview:self.btnCall];
}




@end
