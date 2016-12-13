//
//  WSGetUserByPhone.m
//  TosTov
//
//  Created by Charlie on 12/7/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSGetUserByPhone.h"

@implementation WSGetUserByPhone

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"getuserbyphone";
}

@end
