//
//  MyManager.h
//  TosTov
//
//  Created by Pichzz on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject

@property (nonatomic, strong) NSString *accName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *sessionId;

+(id)sharedManager;

@end
