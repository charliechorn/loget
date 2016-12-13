//
//  TosTovViewController.m
//  TosTov
//
//  Created by Pichzz on 11/11/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "TosTovViewController.h"
#import "SearchDriverViewController.h"


@interface TosTovViewController ()

@property (nonatomic, strong) UITextField *txtOrigin;
@property (nonatomic, strong) UITextField *txtDesc;

@property (nonatomic, strong) UIButton *btnCancelTextOrigin;
@property (nonatomic, strong) UIButton *btnCancelTextDes;
//@property (nonatomic, strong) UISearchBar *searchBarOrigin;
//@property (nonatomic, strong) UISearchBar *searchBarDes;

@property (nonatomic, strong) UITableView *searchTable;

@property (nonatomic, strong) MKPlacemark *selectedOriginPlaceMark;
@property (nonatomic, strong) MKPlacemark *selectedDesPlaceMark;

@property (nonatomic, strong) MKPointAnnotation *annotationOrigin;
@property (nonatomic, strong) MKPointAnnotation *annotationDes;

//@property (nonatomic, retain) NSArray *routes;
//@property (nonatomic, retain) MKPolyline *routeLine; //your line
//@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view

@property (nonatomic, strong) NSMutableArray *polyLinePath;
@property (nonatomic, strong) MKMapView *tripMap;

@property (nonatomic, strong) UIButton *btnMoto;
@property (nonatomic, strong) UIButton *btnTukTuk;
@property (nonatomic, strong) UIButton *btnOrder;

@property (nonatomic, strong) UIView *footerDriver;
@property (nonatomic, strong) UIView *footerPayment;



@end

@implementation TosTovViewController{
    bool isOrigin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addComponents];
    [self setUpLocationManager];
    
}

                                        /** Functionality **/


// Set up location manager
-(void)setUpLocationManager {
    //self.tripMap.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestLocation];
}

// Go back to previous view
-(void)backToMain{
    [self dismissViewControllerAnimated:true completion:nil];
}

// Select a trip and order
-(void)orderTrip{
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


// Show payment view on footer
-(void)showPayment{
    [self.footerDriver removeFromSuperview];
    
    // add footer payment
    self.footerPayment = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 120, /** 67 is additional **/
                                                                 self.view.bounds.size.width - 6, 100)];
    self.footerPayment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerPayment];
    
    // add label distance
    UILabel *lblDistance = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, self.view.bounds.size.width / 3, 10)];
    lblDistance.font = [UIFont systemFontOfSize:12];
    lblDistance.text = @"Distance (2.2 km)";
    [self.footerPayment addSubview:lblDistance];
    
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
    [self.btnOrder addTarget:self action:@selector(orderTrip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnOrder];
    
    
}

/** CLLoationManager Delegate **/
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"au : %d",status);
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"request");
        [self.locationManager requestLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for (int i=0; i<locations.count; i++) {
        NSLog(@"Lo : %@",locations[i]);
    }
    if ([locations objectAtIndex:0]!=nil) {
        CLLocation *location = [locations objectAtIndex:0];
        //MKUserLocation *location = self.mapView.userLocation;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        [self.tripMap setRegion:region animated:YES];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"erro: %@",error);
}

                                   

                                    /** View Decoration **/
-(void)addComponents{
    
    self.title = @"TOS TOV";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:areaTap];
    
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
//    originLogo.frame = CGRectMake(5,10,30,30);
//    originLogo.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:originLogo];
    
    // add textfield origin
//    self.searchBarOrigin = [[UISearchBar alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,routeLogo.frame.origin.y,self.view.bounds.size.width - 50,30)];
//
//    [self.view addSubview:self.searchBarOrigin];
    
    self.txtOrigin = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                  routeLogo.frame.origin.y,
                                                                  self.view.bounds.size.width - 50,30)];
    self.txtOrigin.borderStyle = UITextBorderStyleNone;
    [self.txtOrigin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.txtOrigin.delegate = self;
    [self.view addSubview:self.txtOrigin];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.txtOrigin.frame.origin.x,
                                                           self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 2,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    // add logo destination
//    UIImageView *desLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedMap.png"]];
//    desLogo.frame = CGRectMake(5, originLogo.frame.origin.y + originLogo.bounds.size.height + 5,30,30);
//    desLogo.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:desLogo];
    
 
    // add textfield destination
    
//    self.searchBarDes = [[UISearchBar alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
//                                                                     self.searchBarOrigin.frame.origin.y + self.searchBarOrigin.bounds.size.height + 5, self.view.bounds.size.width - 50, 30)];
//    [self.view addSubview:self.searchBarDes];
    self.txtDesc = [[UITextField alloc]initWithFrame:CGRectMake(routeLogo.frame.origin.x + routeLogo.frame.size.width + 10,
                                                                self.txtOrigin.frame.origin.y + self.txtOrigin.bounds.size.height + 5,
                                                                self.view.bounds.size.width - 50,30)];
    self.txtDesc.borderStyle = UITextBorderStyleNone;
    [self.txtDesc addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.txtDesc.delegate = self;
    [self.view addSubview:self.txtDesc];
    
    // add map
    self.tripMap = [[MKMapView alloc]initWithFrame:CGRectMake(0, routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5,
                                                              self.view.bounds.size.width,
                                                              self.view.bounds.size.height - (routeLogo.frame.origin.y + routeLogo.bounds.size.height + 5))];
    self.tripMap.delegate = self;
    [self.view addSubview:self.tripMap];
    
    // add footer driver
    self.footerDriver = [[UIView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height - 100 - 67, /** 67 is additional **/
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

-(void)textFieldDidChange:(UITextField *)textField{
    
    [self addSearchTableView:textField];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
            request.naturalLanguageQuery = textField.text;
            request.region = self.tripMap.region;
            MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
            [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
    
                if (response==nil) {
                    return;
                }
                self.matchingItems = [[NSArray alloc]initWithArray:response.mapItems];
                [self.searchTable reloadData];
                
            }];
    
   
//    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@?output=json",textField.text];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            NSLog(@"Error is %@",error);
//        }
//        else{
//            NSDictionary *responseRouteData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"Resss : %@", responseRouteData);
//            //NSLog(@"Response is %@",self.responseRouteData);
//            //[self parseResponse:responseRouteData];
//        }
//        
//    }];
//    
//    [task resume];
}

-(void)addSearchTableView :(UITextField *)textField{
    // add cancel
    if (textField == self.txtOrigin) {
        isOrigin = true;
        if (self.btnCancelTextOrigin == nil) {
            self.btnCancelTextOrigin = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnCancelTextOrigin.frame = CGRectMake(0,0, 15, 15);
            [self.btnCancelTextOrigin setBackgroundImage:[UIImage imageNamed:@"TextCancel.png"] forState:UIControlStateNormal];
            self.btnCancelTextOrigin.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.btnCancelTextOrigin addTarget:self action:@selector(cancelTextOrigin) forControlEvents:UIControlEventTouchUpInside];
            self.txtOrigin.rightViewMode = UITextFieldViewModeAlways;
            self.txtOrigin.rightView = self.btnCancelTextOrigin;
        }
        else{
            [self.txtOrigin.rightView setHidden:NO];
        }
    }
    else{
        isOrigin = false;
        if (self.btnCancelTextDes == nil) {
            self.btnCancelTextDes = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnCancelTextDes.frame = CGRectMake(0,0, 15, 15);
            [self.btnCancelTextDes setBackgroundImage:[UIImage imageNamed:@"TextCancel.png"] forState:UIControlStateNormal];
            self.btnCancelTextDes.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.btnCancelTextDes addTarget:self action:@selector(cancelTextDes) forControlEvents:UIControlEventTouchUpInside];
            self.txtDesc.rightViewMode = UITextFieldViewModeAlways;
            self.txtDesc.rightView = self.btnCancelTextDes;
        }
        else{
            [self.txtDesc.rightView setHidden:NO];
        }
    }
    
    
    if (self.searchTable == nil) {
        self.searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.txtDesc.frame.origin.y + self.txtDesc.bounds.size.height,self.view.bounds.size.width, self.view.bounds.size.height)];
        self.searchTable.dataSource = self;
        self.searchTable.delegate= self;
        //self.searchTable.allowsSelection = YES;
        //[self.searchTable setCanCancelContentTouches:NO];
        [self.view addSubview:self.searchTable];
    }
    else{
        [self.searchTable setHidden:NO];
    }
    
}

-(void)cancelTextOrigin{
    [self.txtOrigin.rightView setHidden:YES];
    [self.txtOrigin resignFirstResponder];
    [self.searchTable setHidden:YES];
}
-(void)cancelTextDes{
    [self.txtDesc.rightView setHidden:YES];
    [self.txtDesc resignFirstResponder];
    [self.searchTable setHidden:YES];
}


-(NSString *) parseAdrress:(MKPlacemark *)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = @"";
    NSString *secondSpace = @"";
    NSString *comma = @"";
    NSString *subThoroughfareText = @"";
    NSString *thoroughfareText = @"";
    NSString *localityText = @"";
    NSString *admininstrativeAreaText = @"";
    if (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) {
        firstSpace = @" ";
    }
    //put a comma between streat and city/state
    if ((selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil)) {
        comma = @", ";
    }
    // put a space between "Washington" and "DC"
    if ((selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil)) {
        secondSpace = @" ";
    }
    if (selectedItem.subThoroughfare != nil) {
        subThoroughfareText = selectedItem.subThoroughfare;
    }
    if (selectedItem.thoroughfare != nil) {
        thoroughfareText = selectedItem.thoroughfare;
    }
    if (selectedItem.locality != nil) {
        localityText = selectedItem.locality;
    }
    if (selectedItem.administrativeArea != nil) {
        admininstrativeAreaText = selectedItem.administrativeArea;
    }
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             // street number
                             subThoroughfareText,
                             firstSpace,
                             // street name
                             thoroughfareText,
                             comma,
                             // city
                             localityText,
                             secondSpace,
                             // state
                             admininstrativeAreaText];
    return addressLine;
    
}

-(void)dropPin:(MKPlacemark *)placeMark{
    if (placeMark == self.selectedOriginPlaceMark) {
        [self.tripMap removeAnnotation:self.annotationOrigin];
        self.annotationOrigin = [[MKPointAnnotation alloc]init];
        self.annotationOrigin.coordinate = placeMark.coordinate;
        self.annotationOrigin.title = placeMark.name;
        if (placeMark.locality!=nil) {
            self.annotationOrigin.subtitle = placeMark.locality;
        }
        if (placeMark.administrativeArea!=nil) {
            self.annotationOrigin.subtitle = [self.annotationOrigin.subtitle stringByAppendingString:[NSString stringWithFormat:@" %@",placeMark.administrativeArea]];
        }
        [self.tripMap addAnnotation:self.annotationOrigin];
    }
    else{
        [self.tripMap removeAnnotation:self.annotationDes];
        self.annotationDes = [[MKPointAnnotation alloc]init];
        self.annotationDes.coordinate = placeMark.coordinate;
        self.annotationDes.title = placeMark.name;
        if (placeMark.locality!=nil) {
            self.annotationDes.subtitle = placeMark.locality;
        }
        if (placeMark.administrativeArea!=nil) {
            self.annotationDes.subtitle = [self.annotationDes.subtitle stringByAppendingString:[NSString stringWithFormat:@" %@",placeMark.administrativeArea]];
        }
        [self.tripMap addAnnotation:self.annotationDes];
    }
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(placeMark.coordinate, span);
    [self.tripMap setRegion:region animated:YES];
    
    if (self.annotationOrigin != nil && self.annotationDes != nil) {
        
        CLLocation *a = [[CLLocation alloc]initWithLatitude:self.selectedOriginPlaceMark.coordinate.latitude longitude:self.selectedOriginPlaceMark.coordinate.longitude];
        CLLocation *b = [[CLLocation alloc]initWithLatitude:self.selectedDesPlaceMark.coordinate.latitude longitude:self.selectedDesPlaceMark.coordinate.longitude];
        CLLocationDistance ab = [a distanceFromLocation:b];
        NSLog(@"Distant between ab is : %f ",ab);
        
        
        [self requestRouteData];
    }

}

                                            /** Internet **/
-(void) requestRouteData{
    //NSURL *URL = [NSURL URLWithString:@"http://maps.googleapis.com/maps/api/directions/json"];
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true",self.selectedOriginPlaceMark.coordinate.latitude,self.selectedOriginPlaceMark.coordinate.longitude,self.selectedDesPlaceMark.coordinate.latitude,self.selectedDesPlaceMark.coordinate.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error is %@",error);
        }
        else{
            NSDictionary *responseRouteData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"Response is %@",self.responseRouteData);
            [self parseResponse:responseRouteData];
        }
        
    }];
    
    [task resume];
    
}
- (void)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        self.polyLinePath = [self decodePolyLine:overviewPolyline];
    }
    //NSLog(@"Self polyLinePath is %@", self.polyLinePath);
    
    NSInteger numberOfSteps = self.polyLinePath.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [self.polyLinePath objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        //NSLog(@"Coordinate is %f,%f",coordinate.latitude, coordinate.latitude);
        coordinates[index] = coordinate;
    }
    
    [self.tripMap removeOverlays:self.tripMap.overlays];
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    //NSLog(@"polyline is %@",polyLine);
    [self.tripMap setVisibleMapRect:[polyLine boundingMapRect]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tripMap addOverlay:polyLine];
    });
    
    [self.tripMap setRegion:MKCoordinateRegionForMapRect(polyLine.boundingMapRect)];
    
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


                                            /** MKMapview Delegate **/
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5;
    return renderer;
}

//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//    if(overlay == self.routeLine)
//    {
//        if(self.routeLineView == nil)
//        {
//            self.routeLineView = [[MKPolylineView alloc]initWithPolyline:self.routeLine];
//
//
//        }
//
//        return self.routeLineView;
//    }
//    
//    return nil;
//}

- (MKAnnotationView *)mapView:(MKMapView *)myMap viewForAnnotation:(id < MKAnnotation >)annotation{
    MKAnnotationView *pinView = nil;
    if(annotation != self.tripMap.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[self.tripMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil)
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        if (isOrigin) {
            pinView.image = [UIImage imageNamed:@"OriginPin.png"];
        }
        else {
            pinView.image = [UIImage imageNamed:@"DesPin.png"];
        }
        
    }
    else {
        [self.tripMap.userLocation setTitle:@"I am here"];
    }
    return pinView;
}


                                        /** UITextField Delegate & UITableView datasource **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchingItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = nil;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //[cell setUserInteractionEnabled:YES];
    
    //cell.textLabel.text = @"La";
    MKPlacemark *selectedItem = [self.matchingItems[indexPath.row] placemark];
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = [self parseAdrress:selectedItem];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (isOrigin) {
            MKPlacemark *sel = [self.matchingItems[indexPath.row] placemark];
            self.txtOrigin.text = sel.name;
            self.selectedOriginPlaceMark = sel;
            [self cancelTextOrigin];
            [self dropPin:self.selectedOriginPlaceMark];
    
        }
        else{
            MKPlacemark *sel = [self.matchingItems[indexPath.row] placemark];
            self.txtDesc.text = sel.name;
            self.selectedDesPlaceMark = sel;
            [self cancelTextDes];
            [self dropPin:self.selectedDesPlaceMark];
        }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length > 25 && range.length == 0){
//        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
//        request.naturalLanguageQuery = textField.text;
//        request.region = self.tripMap.region;
//        MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
//        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//            
//            if (response==nil) {
//                return;
//            }
//            self.matchingItems = [[NSArray alloc]initWithArray:response.mapItems];
//            [self.searchTable reloadData];
//            
//        }];
//    }
//    
//
//    return YES;
//}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self addSearchTableView:textField];
    return YES;
}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    return YES;
//}





@end
