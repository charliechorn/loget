//
//  WSBase.h
//  TosTov
//
//  Created by Charlie on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BASE_URL @"http://1-dot-tostov-server.appspot.com/tostovwebservice"
//#define BASE_URL @"http://localhost:8080/tostovwebservice"
@interface WSBase : NSObject

@property (nonatomic, copy) void (^onSuccess)(id,id);
@property (nonatomic, copy) void (^onError)(id,id);

-(void)callRequest;
-(NSString *)getURLSuffix;
-(NSDictionary *)getPostBody;

@end
