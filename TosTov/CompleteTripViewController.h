//
//  CompleteTripViewController.h
//  TosTov
//
//  Created by Charlie on 11/10/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteTripViewController : UIViewController
@property (nonatomic, strong) NSDictionary *tripContent;
-(id)initWithData:(NSDictionary*)data;
@end
