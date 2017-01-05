//
//  WSGetTosGoTripList.m
//  TosTov
//
//  Created by Charlie on 1/3/17.
//  Copyright © 2017 Chhaly. All rights reserved.
//

#import "WSGetTosGoTripList.h"

@implementation WSGetTosGoTripList

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"getordertriplist";
}


@end
