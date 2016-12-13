//
//  ProgressTripViewController.h
//  TosTov
//
//  Created by Pichzz on 11/11/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressTripViewController : UIViewController
@property (nonatomic, strong) NSDictionary *tripContent;
-(id)initWithData:(NSDictionary*)data;
@end
