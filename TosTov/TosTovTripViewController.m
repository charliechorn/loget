//
//  TosTovTripViewController.m
//  TosTov
//
//  Created by Charlie on 12/8/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "TosTovTripViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchDriverViewController.h"
#import "WSOrderTrip.h"
#import "WSOrderTosSendTrip.h"
#import "Reachability.h"
#import "MyManager.h"

@interface TosTovTripViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate>


@property (nonatomic, strong) UITextField *txtOrigin;
@property (nonatomic, strong) UITextField *txtDesc;
@property (nonatomic, strong) UIButton *btnMoto;
@property (nonatomic, strong) UIButton *btnTukTuk;
@property (nonatomic, strong) UIButton *btnOrder;

@property (nonatomic, strong) UIView *footerDriver;
@property (nonatomic, strong) UIView *footerPayment;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker *originMark;
@property (nonatomic, strong) GMSMarker *desMark;
@property (nonatomic) CLLocationCoordinate2D originCoordinate;
@property (nonatomic) CLLocationCoordinate2D desCoordinate;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) UILabel *lblDistance;


@end

@implementation TosTovTripViewController{
    bool isOrigin;
    int count;
}

-(id)initWithWeight:(NSString *)weight unit:(NSString *)unit description:(NSString *)sendDesc receiverPhone:(NSString *)receiverPhone refCode:(NSString *)refCode isInsurance:(NSString *)isInsurance isPrepaid:(NSString *)isPrepaid andIsTosTov:(NSString *)isTosTov{
    if(self=[super init]){
        self.weight = weight;
        self.unit = unit;
        self.sendDesc = sendDesc;
        self.receiverPhone = receiverPhone;
        self.refCode = refCode;
        self.isInsurance = isInsurance;
        self.isPrepaid = isPrepaid;
        self.isTosTov = isTosTov;
    }
    return self;
}

-(id)initWithIsTosTov:(NSString *)isTosTov{
    if(self=[super init]){
        self.isTosTov = isTosTov;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
    isOrigin = true;
    count = 0;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
//    GMSMarker *marker = [[GMSMarker alloc]init];
//    marker.position = CLLocationCoordinate2DMake(11.562108, 104.888535);
//    marker.title = @"Phnom Penh";
//    marker.snippet = @"Cambodia";
//    marker.map = self.mapView;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.footerPayment removeFromSuperview];
    [self.btnOrder removeFromSuperview];
    [self showDriverFooter];
}

// Go back to previous view
-(void)backToMain{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)submitOrder {
    if ([self.isTosTov isEqualToString:@"1"]) {
        [self orderTrip];
    }else{
        [self orderTosSendTrip];
    }
}

// Select a trip and order
-(void)orderTrip{
    if ([self.txtOrigin.text isEqualToString:@""] || [self.txtDesc.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"" message:@"Please input locations."];
        return;
    }
    
    // Order
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }else {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        NSString *userId = [NSString stringWithFormat:@"%@",[[MyManager sharedManager]userId]];
        [parameters setObject:userId  forKey:@"userId"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.originCoordinate.latitude] forKey:@"originLatitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.originCoordinate.longitude] forKey:@"originLongtitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.desCoordinate.latitude] forKey:@"desLatitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.desCoordinate.longitude] forKey:@"desLongtitude"];
        [parameters setObject:self.txtOrigin.text forKey:@"originText"];
        [parameters setObject:self.txtDesc.text forKey:@"desText"];
        
        NSLog(@"Parameter are : %@",parameters);
        __weak TosTovTripViewController *weakSelf = self;
        WSOrderTrip *orderTripService = [[WSOrderTrip alloc]init];
        orderTripService.postBody = parameters;
        
        orderTripService.onSuccess = ^(id contr, id result){
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
            NSLog(@" trip is : %@",result);
            
        };
        orderTripService.onError = ^(id contr, id result){
            dispatch_async(dispatch_get_main_queue(), ^{
               
                NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",[response objectForKey:@"error"]]];
            });
        };
        
        [orderTripService callRequest];
    }
    
    SearchDriverViewController *searchVC = [[SearchDriverViewController alloc]init];
    searchVC.view.frame = self.view.bounds;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:true completion:nil];
}

-(void)orderTosSendTrip{
    if ([self.txtOrigin.text isEqualToString:@""] || [self.txtDesc.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"" message:@"Please input locations."];
        return;
    }
    
    // Order
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }else{
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        NSString *userId = [NSString stringWithFormat:@"%@",[[MyManager sharedManager]userId]];
        [parameters setObject:userId  forKey:@"userId"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.originCoordinate.latitude] forKey:@"originLatitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.originCoordinate.longitude] forKey:@"originLongtitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.desCoordinate.latitude] forKey:@"desLatitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.desCoordinate.longitude] forKey:@"desLongtitude"];
        [parameters setObject:self.txtOrigin.text forKey:@"originText"];
        [parameters setObject:self.txtDesc.text forKey:@"desText"];
        
        [parameters setObject:[NSNumber numberWithDouble:self.weight.doubleValue] forKey:@"weight"];
        [parameters setObject:[NSNumber numberWithInt:self.unit.integerValue ] forKey:@"unit"];
        [parameters setObject:self.sendDesc forKey:@"desription"];
        [parameters setObject:self.receiverPhone forKey:@"receiverPhone"];
        [parameters setObject:self.refCode forKey:@"refCode"];
        [parameters setObject:self.isInsurance forKey:@"isInsurance"];
        [parameters setObject:self.isPrepaid forKey:@"isPrepaid"];
        
        NSLog(@"Parameter are : %@",parameters);
        __weak TosTovTripViewController *weakSelf = self;
        WSOrderTosSendTrip *orderTripService = [[WSOrderTosSendTrip alloc]init];
        orderTripService.postBody = parameters;
        
        orderTripService.onSuccess = ^(id contr, id result){
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //            });
            NSLog(@" trip is : %@",result);
            
        };
        orderTripService.onError = ^(id contr, id result){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",[response objectForKey:@"error"]]];
            });
        };
        
        [orderTripService callRequest];
    }
    
    SearchDriverViewController *searchVC = [[SearchDriverViewController alloc]init];
    searchVC.view.frame = self.view.bounds;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:true completion:nil];
        
    
}

// Select on moto driver
-(void)clickOnMoto{
    [self showPayment];
}

// Select on tuk tuk driver
-(void)clickOnTukTuk{
    [self showPayment];
}

// Alert any message with title
-(void)alertBoxWithMessage : (NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:true completion:nil];
}


// Drap marker
-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
    if (marker == self.originMark) {
        self.originCoordinate = marker.position;
    }
    else{
        self.desCoordinate = marker.position;
    }
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:marker.position completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        GMSAddress *address = [response results][0];
        NSString *addrText = [NSString stringWithFormat:@"%@, %@",address.lines[0], address.lines[1]];
        if (marker == self.originMark) {
            self.txtOrigin.text = addrText;
        }
        else {
            self.txtDesc.text = addrText;
        }
        
    }];
    if (count>=2) {
        [self drawRouteLine];
    }
    
}

// Tap on map
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    count +=1;
    __block NSString *addrText = @"";
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        for(GMSAddress* addressObj in [response results])
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSAddress *address = [response results][0];
            addrText = [NSString stringWithFormat:@"%@, %@",address.lines[0], address.lines[1]];
            if (isOrigin) {
                self.originCoordinate = coordinate;
                UIImageView *pin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OriginPin.png"]];
                pin.frame = CGRectMake(0, 0, 15, 23);
                if (self.originMark) {
                    self.originMark.map = nil;
                }
                self.originMark = [[GMSMarker alloc]init];
                [self.originMark setDraggable:YES];
                self.originMark.position = coordinate;
                self.originMark.iconView = pin;
                self.originMark.map = self.mapView;
                NSLog(@"Text : %@", addrText);
                self.txtOrigin.text = addrText;
                isOrigin = false;
            }
            else{
                self.desCoordinate = coordinate;
                UIImageView *pin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DesPin.png"]];
                pin.frame = CGRectMake(0, 0, 15, 23);
                if (self.desMark) {
                    self.desMark.map = nil;
                }
                self.desMark = [[GMSMarker alloc]init];
                [self.desMark setDraggable:YES];
                self.desMark.position = coordinate;
                self.desMark.iconView = pin;
                self.desMark.map = self.mapView;
                NSLog(@"Text : %@", addrText);
                self.txtDesc.text = addrText;
                isOrigin = true;
            }
            if(![self.txtOrigin.text isEqualToString:@""] && ![self.txtDesc.text isEqualToString:@""]){
                
                [self drawRouteLine];
            }
            
//            if (count>=2) {
//                [self drawRouteLine];
//                
//            }
            
        });
        
        
    }];
    
    
    
    
}

-(void)drawRouteLine{
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true",self.originCoordinate.latitude,self.originCoordinate.longitude,self.desCoordinate.latitude,self.desCoordinate.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error is %@",error);
        }
        else{
            NSDictionary *responseRouteData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"route is : %@",[responseRouteData objectForKey:@"routes"][0][@"overview_polyline"]  [@"points"]);
            GMSPath *pathRoute  = [GMSPath pathFromEncodedPath:[responseRouteData objectForKey:@"routes"][0][@"overview_polyline"]  [@"points"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.polyline) {
                    self.polyline.map = nil;
                }
                self.polyline = [GMSPolyline polylineWithPath:pathRoute];
                self.polyline.strokeColor = [UIColor colorWithRed:0.15 green:0.60 blue:0.96 alpha:1.0];
                self.polyline.strokeWidth = 5.0f;
                self.polyline.map = self.mapView;
            });
            
        }
        
    }];
    
    [task resume];
}



                                        /** CLLoationManager Delegate **/
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Status %d", status);
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Status accept");
        [self.locationManager requestLocation];
        [self.mapView setMyLocationEnabled:YES];
        [self.mapView.settings setMyLocationButton:YES];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for (int i=0; i<locations.count; i++) {
        NSLog(@"Lo : %@",locations[i]);
    }
    if ([locations objectAtIndex:0]!=nil){
        self.mapView.camera = [[GMSCameraPosition alloc]initWithTarget:[locations objectAtIndex:0].coordinate zoom:15 bearing:0 viewingAngle:0];
        [self.locationManager stopUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"erro: %@",error);
}

-(void)showDistance{
    CLLocation *origin = [[CLLocation alloc]initWithLatitude:self.originCoordinate.latitude longitude:self.originCoordinate.longitude];
    CLLocation *des = [[CLLocation alloc]initWithLatitude:self.desCoordinate.latitude longitude:self.desCoordinate.longitude];
    float distance = [origin distanceFromLocation:des]/1000;
    self.lblDistance.text = [NSString stringWithFormat:@"Distance (%0.2f km)",distance];
}

                                    /** View Decoration **/
-(void)addComponents{
    
    self.title = @"TOS TOV";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    // add place icon
    UIImageView *routeLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlaceIcon.png"]];
    routeLogo.frame = CGRectMake(10, 10, 15 ,60);
    routeLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:routeLogo];
    
    
    self.txtOrigin = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                  routeLogo.frame.origin.y,
                                                                  self.view.bounds.size.width - 50,30)];
    self.txtOrigin.borderStyle = UITextBorderStyleNone;
    [self.txtOrigin setEnabled:NO];
    [self.view addSubview:self.txtOrigin];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.txtOrigin.frame.origin.x,
                                                           self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 2,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    self.txtDesc = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 5,
                                                                self.view.bounds.size.width - 50,30)];
    self.txtDesc.borderStyle = UITextBorderStyleNone;
    [self.txtDesc setEnabled:NO];
    [self.view addSubview:self.txtDesc];
    
    // add map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:11.562108 longitude:104.888535 zoom:14];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.delegate = self;
    
    
    self.mapView.frame = CGRectMake(0, routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5,
                                                              self.view.bounds.size.width,
                                                              self.view.bounds.size.height - (routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5));

    [self.view addSubview:self.mapView];
    
    
    
}

// Show driver view
-(void)showDriverFooter {
    // add footer driver
    self.footerDriver = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 100, /** -67 is additional **/
                                                                self.view.bounds.size.width-6, 100)];
    self.footerDriver.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerDriver];
    
    
    // add button motmo
    self.btnMoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMoto.frame = CGRectMake(0, 0, self.footerDriver.bounds.size.width / 2, self.footerDriver.bounds.size.height);
    self.btnMoto.backgroundColor = [UIColor whiteColor];
    UIImage *buttonImageMoto = [UIImage imageNamed:@"MotoIcon.png"];
    [self.btnMoto setImage:buttonImageMoto forState:UIControlStateNormal];
    [self.btnMoto addTarget:self action:@selector(clickOnMoto) forControlEvents:UIControlEventTouchUpInside];
    [self.footerDriver addSubview:self.btnMoto];
    
    // add button tuk tuk
    self.btnTukTuk = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnTukTuk.frame = CGRectMake(self.footerDriver.bounds.size.width / 2, 0, self.footerDriver.bounds.size.width / 2, self.footerDriver.bounds.size.height);
    self.btnTukTuk.backgroundColor = [UIColor whiteColor];
    UIImage *buttonImageTukTuk = [UIImage imageNamed:@"TukTukIcon.png"];
    [self.btnTukTuk setImage:buttonImageTukTuk forState:UIControlStateNormal];
    [self.btnTukTuk addTarget:self action:@selector(clickOnTukTuk) forControlEvents:UIControlEventTouchUpInside];
    [self.footerDriver addSubview:self.btnTukTuk];
}



// Show payment view on footer
-(void)showPayment{
    [self.footerDriver removeFromSuperview];
    
    // add footer payment
    self.footerPayment = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 120, /** 67 is additional **/
                                                                 self.view.bounds.size.width - 6, 100)];
    self.footerPayment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerPayment];
    
    // add label distance
    self.lblDistance = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, self.view.bounds.size.width / 2, 10)];
    self.lblDistance.font = [UIFont systemFontOfSize:12];
    //self.lblDistance.text = @"Distance (0.0 km)";
    [self.footerPayment addSubview:self.lblDistance];
    [self showDistance];
    
    // add label price
    NSString *priceStr = @"Price 8000R";
    CGFloat priceWidth = [priceStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.footerPayment.bounds.size.width-(priceWidth), 5,
                                                                 priceWidth, 10)];
    lblPrice.font = [UIFont systemFontOfSize:12];
    lblPrice.textColor = [UIColor redColor];
    lblPrice.text = priceStr;
    [self.footerPayment addSubview:lblPrice];
    
    // add line 1
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(2, 18, self.footerPayment.bounds.size.width - 4, 1)];
    line1.backgroundColor = [UIColor blackColor];
    [self.footerPayment addSubview:line1];
    
    // add bullet logo 1
    UIImageView *bulletLogo1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BulletIcon.png"]];
    bulletLogo1.frame = CGRectMake(5, line1.frame.origin.y+6, 15,15);
    bulletLogo1.contentMode = UIViewContentModeScaleAspectFit;
    [self.footerPayment addSubview:bulletLogo1];
    
    // add label amount
    UILabel *lblAmount = [[UILabel alloc]initWithFrame:CGRectMake(bulletLogo1.frame.origin.x + bulletLogo1.bounds.size.width + 5,
                                                                  bulletLogo1.frame.origin.y, self.footerPayment.bounds.size.width / 2, 30)];
    //lblAmount.layer.borderWidth = 1;
    //lblAmount.layer.borderColor = [UIColor greenColor].CGColor;
    lblAmount.numberOfLines = 2;
    lblAmount.font = [UIFont systemFontOfSize:12];
    lblAmount.text = @"MY ACCOUNT USD 0.00 \n(5% discount)";
    [self.footerPayment addSubview:lblAmount];
    
    // add label top up
    NSString *topUpStr = @"TOP UP";
    CGFloat topUpWidth = [topUpStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]}].width;
    UILabel *lblTopUp = [[UILabel alloc]initWithFrame:CGRectMake(self.footerPayment.bounds.size.width-topUpWidth - 10,
                                                                 bulletLogo1.frame.origin.y, topUpWidth + 10, 10)];
    lblTopUp.textColor = [UIColor greenColor];
    lblTopUp.font = [UIFont systemFontOfSize:12];
    lblTopUp.text = @"TOP UP";
    [self.footerPayment addSubview:lblTopUp];
    
    // add bullet logo 2
    UIImageView *bulletLogo2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BulletSelectedIcon.png"]];
    bulletLogo2.frame = CGRectMake(5, bulletLogo1.frame.origin.y + bulletLogo1.bounds.size.height + 20, 15,15);
    bulletLogo2.contentMode = UIViewContentModeScaleAspectFit;
    [self.footerPayment addSubview:bulletLogo2];
    
    // add label cash
    UILabel *lblCash = [[UILabel alloc]initWithFrame:CGRectMake(bulletLogo2.frame.origin.x + bulletLogo2.bounds.size.width + 5,
                                                                bulletLogo2.frame.origin.y + 3, 50, 10)];
    lblCash.font = [UIFont systemFontOfSize:12];
    lblCash.text = @"CASH";
    [self.footerPayment addSubview:lblCash];
    
    // add button order
    self.btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnOrder.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    self.btnOrder.layer.borderWidth = 1;
    self.btnOrder.backgroundColor = [UIColor greenColor];
    NSString *orderStr = @"ORDER";
    CGFloat orderWidth = [orderStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:13]}].width;
    UILabel *lblOrder = [[UILabel alloc]initWithFrame:CGRectMake((self.btnOrder.bounds.size.width - orderWidth - 5) / 2,
                                                                 15, orderWidth + 5, 10)];
    lblOrder.font = [UIFont systemFontOfSize:13];
    lblOrder.textColor = [UIColor whiteColor];
    lblOrder.text = orderStr;
    [self.btnOrder addSubview:lblOrder];
    [self.btnOrder addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnOrder];
    
    
}





@end
