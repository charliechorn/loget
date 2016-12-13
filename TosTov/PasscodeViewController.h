//
//  PasscodeViewController.h
//  TosTov
//
//  Created by Charlie on 11/4/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *accName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
-(id)initWithAccName:(NSString *)accName phoneNumber:(NSString *)phone andPassword:(NSString *)password;
@end
