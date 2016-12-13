//
//  MyManager.m
//  TosTov
//
//  Created by Charlie on 12/6/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

+(id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

@end
