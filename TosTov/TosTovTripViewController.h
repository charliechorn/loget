//
//  TosTovTripViewController.h
//  TosTov
//
//  Created by Charlie on 12/8/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TosTovTripViewController : UIViewController

@property (nonatomic,strong) NSString *weight;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *sendDesc;
@property (nonatomic, strong) NSString *receiverPhone;
@property (nonatomic, strong) NSString *refCode;
@property (nonatomic ,strong) NSString *isInsurance;
@property (nonatomic, strong) NSString *isPrepaid;

@property (nonatomic, strong) NSString *isTosTov;

-(id)initWithWeight:(NSString *)weight unit:(NSString *)unit description:(NSString *)sendDesc receiverPhone:(NSString *)receiverPhone refCode:(NSString *)refCode isInsurance:(NSString *)isInsurance isPrepaid:(NSString *)isPrepaid andIsTosTov:(NSString *)isTosTov;

-(id)initWithIsTosTov:(NSString *)isTosTov;

@end
