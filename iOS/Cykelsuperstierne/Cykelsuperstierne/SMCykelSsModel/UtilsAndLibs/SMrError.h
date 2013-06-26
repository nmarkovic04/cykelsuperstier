//
//  SMError.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/20/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _eSmrErrorType{
    ET_NOTIFICATION = 0,// nothing actually happened, just filling it with some info
    ET_WARNING = 1,     // nothing serious happen. Although, there are some irregularities 
    ET_FAILED = 2       // operation/action failed
} eSmrErrorType;

@interface SMrError : NSObject
@property(nonatomic, strong) NSDictionary * errorData;
@property(nonatomic, strong) NSString * errorDescription;
@property(nonatomic, assign) eSmrErrorType errorType;

-(id) initWithNSError:(NSError*) error;

-(void) addDataWithKey:(const NSString*)key andValue:(NSObject*)value;
-(void) addDataToArrayWithKey:(const NSString*)key andValue:(NSObject*)value;
-(BOOL) raiseTypeTo:(eSmrErrorType) type;
@end
