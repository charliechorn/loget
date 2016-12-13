//
//  TosTovViewController.h
//  TosTov
//
//  Created by Pichzz on 11/11/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface TosTovViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocation *originLocation;
@property (nonatomic, strong) CLLocation *desLocation;

@property (nonatomic, strong) NSArray *matchingItems;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
