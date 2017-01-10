//
//  MyUtils.m
//  TosTov
//
//  Created by Charlie on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "MyUtils.h"
#import "Reachability.h"

@implementation MyUtils

+(NSString *)getFormatDateWithString:(NSString *)str {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
    
    NSDate *date = [dateFormat dateFromString:str];
//
//    [dateFormat setDateFormat:@"dd MMM, hh:mm"];
//    return [dateFormat stringFromDate:date];
//    
//    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
//    // or Timezone with specific name like
//    // [NSTimeZone timeZoneWithName:@"Europe/Riga"] (see link below)
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
//    NSString *localDateString = [dateFormatter stringFromDate:date];
//    
//    return localDateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(void)alertBoxWithMessage:(NSString *)title message:(NSString *)message andController:(UIViewController *)contr{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOk];
        [contr presentViewController:alert animated:true completion:nil];
    });
}
@end
