//
//  WSSignUp.m
//  TosTov
//
//  Created by Pichzz on 12/7/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSSignUp.h"

@implementation WSSignUp

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"register";
}

@end
