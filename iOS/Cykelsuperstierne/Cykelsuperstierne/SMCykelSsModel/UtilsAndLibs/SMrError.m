//
//  SMError.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/20/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrError.h"

@implementation SMrError

-(id) init{
    self = [super init];
    if(self){
        self.errorType = ET_NOTIFICATION;
    }
    return self;
}

-(id) initWithNSError:(NSError *)error{
    self = [super init];
    if(self){
        self.errorData = error.userInfo;
        self.errorType = ET_FAILED;
        self.errorDescription = error.description;
    }
    return self;
}

-(void) addDataWithKey:(const NSString*)key andValue:(NSObject*)value{
    if(!self.errorData) self.errorData = [NSMutableDictionary new];
    [self.errorData setValue:value forKey:[key copy]];
}

-(void) addDataToArrayWithKey:(const NSString*)key andValue:(NSObject*)value{
    if(!self.errorData) self.errorData = [NSMutableDictionary new];
    NSString * keyCopy = [key copy];
    NSObject * existingData = [self.errorData valueForKey:keyCopy];
    
    if(existingData && [existingData isKindOfClass:[NSMutableArray class]]){
        [((NSMutableArray*)existingData) addObject:value];
    } else {
        [self.errorData setValue:[NSMutableArray arrayWithObject:value] forKey:keyCopy];
    }
}

-(BOOL) raiseTypeTo:(eSmrErrorType) type{
    if(self.errorType >= type) return NO;
    self.errorType = type;
    return YES;
}

@end
