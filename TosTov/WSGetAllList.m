//
//  WSGetAllList.m
//  TosTov
//
//  Created by Charlie on 1/5/17.
//  Copyright © 2017 Chhaly. All rights reserved.
//

#import "WSGetAllList.h"

@implementation WSGetAllList

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"getalllist";
}

@end
