//
//  WSChangePassword.m
//  TosTov
//
//  Created by Pichzz on 12/7/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSChangePassword.h"

@implementation WSChangePassword

-(NSDictionary *)getPostBody{
    return self.postBody;
}

-(NSString *)getURLSuffix{
    return @"changepassword";
}

@end
