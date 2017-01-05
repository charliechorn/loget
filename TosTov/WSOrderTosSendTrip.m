//
//  WSOrderTosSendTrip.m
//  TosTov
//
//  Created by Charlie on 1/5/17.
//  Copyright © 2017 Chhaly. All rights reserved.
//

#import "WSOrderTosSendTrip.h"

@implementation WSOrderTosSendTrip

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"ordersendtrip";
}


@end
