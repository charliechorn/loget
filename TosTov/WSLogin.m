//
//  WSLogin.m
//  TosTov
//
//  Created by Pichzz on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSLogin.h"

@implementation WSLogin

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"login";
}
@end
