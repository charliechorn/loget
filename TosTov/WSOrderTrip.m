//
//  WSOrderTrip.m
//  TosTov
//
//  Created by Charlie on 12/28/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSOrderTrip.h"

@implementation WSOrderTrip

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"orderTrip";
}

@end
