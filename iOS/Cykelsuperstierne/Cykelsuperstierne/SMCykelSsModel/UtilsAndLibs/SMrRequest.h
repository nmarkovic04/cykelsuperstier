//
//  SMRequest.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/20/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMrError.h"



@interface SMrRequest : NSBlockOperation<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

typedef void (^SMRequestCompletionBlock) (SMrRequest*);
typedef enum _eSmRequestState{
    RS_NOTINITIALIZED,
    RS_READY,
    RS_REQUESTED,
    RS_WAITINGFORRESPONSE,
    RS_RESPONSERECEIVED
} eSmRequestState;

@property(nonatomic, strong, readonly)  NSData * receivedData;
@property(nonatomic, strong, readonly)  NSString * dataType;
@property(nonatomic, readonly)          NSInteger statusCode;

@property(nonatomic, strong) NSString * mainUrl;    //eg. www.myhost.com
@property(nonatomic, strong) NSString * httpMethod; //eg. GET, POST ... default is GET
@property(nonatomic, strong) NSMutableDictionary * headerFields; //key[NSString*] , value[NSString*]
@property(nonatomic, strong) NSData *  postData;
@property(nonatomic, strong) NSString * service; //eg. login => www.myhost.com/login
@property(nonatomic, strong) NSMutableDictionary * arguments; //eg. "user":"John", "age":26 => www.myhost.com/login?user=John&age=26
@property(nonatomic, assign)    BOOL secureConnection;
@property(nonatomic, readonly)  eSmRequestState state;
@property(nonatomic, retain, readonly) SMrError * requestError;

@property(nonatomic) float timeout;
-(id) initWithMainUrl:(NSString*)mainUrl;
-(id) initWithMainUrl:(NSString*)mainUrl andService:(NSString*)service;
-(id) initWithMainUrl:(NSString*)mainUrl andHttpMethod:(NSString*)httpMethod;

-(SMrError*) requestWithCompletion:(SMRequestCompletionBlock) completion;

//utility methods
-(void) clearHeaderFields;
-(void) addHeaderValue:(NSString*)value forField:(NSString*)field;
-(void) clearPostData;
-(SMrError*) createPostDataFromJSONDict:(NSDictionary*)jsonObject;
-(SMrError*) createPostDataFromJSONString:(NSString*)jsonObject;

@end
