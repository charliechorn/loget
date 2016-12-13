//
//  CompleteTripViewController.m
//  TosTov
//
//  Created by Charlie on 11/10/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "CompleteTripViewController.h"

@interface CompleteTripViewController ()

@property (nonatomic, strong) UITextField *txtOrigin;
@property (nonatomic, strong) UITextField *txtDesc;
//@property (nonatomic, strong) MKMapView *tripMap;
@property (nonatomic, strong) GMSMapView *mapView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation CompleteTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addComponents];
    //NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
    
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

    
    
    // add place icon
    UIImageView *routeLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlaceIcon.png"]];
    routeLogo.frame = CGRectMake(10, 10, 15 ,60);
    routeLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:routeLogo];
    
    
    // add logo origin
//    UIImageView *originLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedMap.png"]];
//    originLogo.frame = CGRectMake(5, 10,30,30);
//    originLogo.contentMode = UIViewContentModeScaleAspectFit;
    //[self.view addSubview:originLogo];
    
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
    //[self.view addSubview:desLogo];
    
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
//                                                             self.view.bounds.size.width,
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
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 130 -67, /** 67 is additional **/
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
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.footerView.bounds.size.width-(priceWidth), 5,
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
    driverImage.frame = CGRectMake(15,line1.frame.origin.y+6, 70, 70);
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
                                                                     driverImage.frame.origin.y,
                                                                      driverNameWidth, 12)];
    lblDriverName.font = [UIFont systemFontOfSize:12];
    lblDriverName.text = driverNameStr;
    [self.footerView addSubview:lblDriverName];
    
    // add order number label
    NSString *orderNumStr = @"Order No: 888777999";
    CGFloat orderNumWidth = [orderNumStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(lblDriverName.frame.origin.x,
                                                                   lblDriverName.frame.origin.y + lblDriverName.bounds.size.height + 8,
                                                                    orderNumWidth, 12)];
    lblOrderNum.font = [UIFont systemFontOfSize:12];
    lblOrderNum.text = orderNumStr;
    [self.footerView addSubview:lblOrderNum];
    
    
    // check if status is completed or cancelled
    if ([[self.tripContent objectForKey:@"status"]isEqualToString:@"Completed"]) {
        // add lable status
        UILabel *lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(lblDriverName.frame.origin.x,
                                                                      lblOrderNum.frame.origin.y + lblOrderNum.bounds.size.height + 8,
                                                                      80, 12)];
        lblStatus.font = [UIFont systemFontOfSize:12];
        lblStatus.textColor = [UIColor greenColor];
        lblStatus.text = @"Completed";
        [self.footerView addSubview:lblStatus];
        
        // add label rate me
        NSString *rateMeStr = @"";
        NSLog(@"the trip is %@",[self.tripContent objectForKey:@"isRated"]);
        if ([[self.tripContent objectForKey:@"isRated"]isEqualToString:@"no"]) {
            rateMeStr = @"Rate me:";
        }
        else{
            rateMeStr = @"Rated:";
        }
        CGFloat rateMeWidth = [rateMeStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
        UILabel *lblRateMe = [[UILabel alloc]initWithFrame:CGRectMake(lblStatus.frame.origin.x,
                                                                      lblStatus.frame.origin.y + lblStatus.bounds.size.height + 8,
                                                                      rateMeWidth, 12)];
        lblRateMe.font = [UIFont systemFontOfSize:12];
        lblRateMe.text = rateMeStr;
        [self.footerView addSubview:lblRateMe];
        
        // add rate star
        // star 1
        UIImageView *rateStar1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RatedStar.png"]];
        rateStar1.frame = CGRectMake(lblRateMe.frame.origin.x + lblRateMe.bounds.size.width + 15,
                                     lblRateMe.frame.origin.y, 12, 12);
        [self.footerView addSubview:rateStar1];
        
        // star 2
        UIImageView *rateStar2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RatedStar.png"]];
        rateStar2.frame = CGRectMake(rateStar1.frame.origin.x + rateStar1.bounds.size.width + 5,
                                     lblRateMe.frame.origin.y, 12, 12);
        [self.footerView addSubview:rateStar2];
        
        // star 3
        UIImageView *rateStar3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RatedStar.png"]];
        rateStar3.frame = CGRectMake(rateStar2.frame.origin.x + rateStar2.bounds.size.width + 5,
                                     lblRateMe.frame.origin.y, 12, 12);
        [self.footerView addSubview:rateStar3];
        
        // start 4
        UIImageView *rateStar4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RatedStar.png"]];
        rateStar4.frame = CGRectMake(rateStar3.frame.origin.x + rateStar3.bounds.size.width + 5,
                                     lblRateMe.frame.origin.y, 12, 12);
        [self.footerView addSubview:rateStar4];
        
        // start 5
        UIImageView *rateStar5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RatedStar.png"]];
        rateStar5.frame = CGRectMake(rateStar4.frame.origin.x + rateStar4.bounds.size.width + 5,
                                     lblRateMe.frame.origin.y, 12, 12);
        [self.footerView addSubview:rateStar5];
    }else{
        // add lable status
        UILabel *lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(lblDriverName.frame.origin.x,
                                                                      lblOrderNum.frame.origin.y + lblOrderNum.bounds.size.height + 8,
                                                                      80, 12)];
        lblStatus.font = [UIFont systemFontOfSize:12];
        lblStatus.textColor = [UIColor redColor];
        lblStatus.text = @"Cancelled";
        [self.footerView addSubview:lblStatus];
    }
    
   
    
    // add line 3
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(line1.frame.origin.x,
                                                           driverImage.frame.origin.y + driverImage.bounds.size.height + 5,
                                                            line1.bounds.size.width, 1)];
    line3.backgroundColor = [UIColor blackColor];
    [self.footerView addSubview:line3];
    
    // add need help
    UIView *needHelp = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               line3.frame.origin.y + 2, self.footerView.bounds.size.width, 30)];
    //needHelp.layer.borderColor = [UIColor redColor].CGColor;
    //needHelp.layer.borderWidth = 1;
    [self.footerView addSubview:needHelp];
    
    NSString *needHelpStr = @"NEED HELP?";
    CGFloat needHelpWidth = [needHelpStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:13]}].width;
    UILabel *lblNeedHelp = [[UILabel alloc]initWithFrame:CGRectMake((needHelp.bounds.size.width - needHelpWidth) / 2,
                                                                    10, needHelpWidth, 10)];
    lblNeedHelp.font = [UIFont systemFontOfSize:13];
    lblNeedHelp.text = needHelpStr;
    [needHelp addSubview: lblNeedHelp];
    
}


@end
