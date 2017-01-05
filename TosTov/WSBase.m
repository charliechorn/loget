//
//  WSBase.m
//  TosTov
//
//  Created by Charlie on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "WSBase.h"

@implementation WSBase
-(void)callRequest{

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSString *dataURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,[self getURLSuffix]];
    
    //NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self getPostBody] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL *url = [[NSURL alloc]initWithString:dataURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = jsonData;
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle request error
        if (error) {
            NSLog(@"Error is %@", error);
//            resultData = @{@"error":error};
            self.onError(self,@{@"error":error});
            
        }else{
            //NSArray *arrDic = [NSArray arrayWithObject:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]];
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //NSDictionary *responseData = [arrDic objectAtIndex:0];
            NSLog(@"response data is %@", responseData);
            if (responseData[@"error"]) {
                self.onError(self,@{@"error":responseData[@"error"]});
            }else{
                self.onSuccess(self,responseData);
            }
        }
        
    }];
    [task resume];

}

-(NSDictionary *)getPostBody{
    return nil;
}

-(NSString *)getURLSuffix{
    return @"";
}

@end
