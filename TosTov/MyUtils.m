//
//  MyUtils.m
//  TosTov
//
//  Created by Pichzz on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "MyUtils.h"
#import "Reachability.h"

@implementation MyUtils


-(void)alertBoxWithMessage:(NSString *)title message:(NSString *)message andController:(UIViewController *)contr{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOk];
        [contr presentViewController:alert animated:true completion:nil];
    });
}
@end
