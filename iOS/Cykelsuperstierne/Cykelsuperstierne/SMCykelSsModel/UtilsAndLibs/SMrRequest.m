//
//  SMRequest.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/20/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrRequest.h"

#define MAX_CONCURENTREQUESTS 20

#pragma mark error keys -
static const NSString * INVALID_ARGUMENT = @"invalid";
static const NSString * IGNORED_ARGUMENT = @"ignored";
static const NSString * CONNECTION_ERROR = @"connErr";
#pragma mark -

@interface SMrRequest()
@property(nonatomic, readwrite)  eSmRequestState state;
@property(nonatomic, strong) SMRequestCompletionBlock requestCompletionBlock;
@property(nonatomic, retain) NSURLRequest * urlRequest;
@property(nonatomic, retain, readwrite) SMrError * requestError;


@property(nonatomic, strong, readwrite)  NSData * receivedData;
@property(nonatomic, strong, readwrite)  NSString * dataType;
@property(nonatomic, readwrite)          NSInteger statusCode;

@property(nonatomic, strong) NSURLConnection * connection;

+(NSOperationQueue*) sharedQueue;
@end


@implementation SMrRequest



#pragma mark - initialization
- (id)init{
//    self = [super initWithTarget:self selector:@selector(_startConnection) object:nil];
    self = [super init];
    if(self){
        [self baseInit];
    }
    return self;
}

-(id) initWithMainUrl:(NSString*)mainUrl{
    //    self = [super initWithTarget:self selector:@selector(_startConnection) object:nil];
    self = [super init];
    if(self){
        __weak SMrRequest * localSelfCopy = self;
        [self addExecutionBlock:^(){
            [localSelfCopy _startConnection];
        }];
        [self baseInit];
        self.mainUrl = mainUrl;
    }
    
    return self;
}

-(id) initWithMainUrl:(NSString*)mainUrl andService:(NSString*)service{
    //    self = [super initWithTarget:self selector:@selector(_startConnection) object:nil];
    self = [super init];
    
    if(self){
        [self baseInit];
        self.mainUrl = mainUrl;
        self.service = service;
    }
    
    return self;
}

-(id) initWithMainUrl:(NSString*)mainUrl andHttpMethod:(NSString*)httpMethod{
    //    self = [super initWithTarget:self selector:@selector(_startConnection) object:nil];
    self = [super init];

    if(self){
        [self baseInit];
        self.mainUrl = mainUrl;
        self.httpMethod = httpMethod;
    }

    return self;
}

-(void)baseInit{
    
    self.mainUrl = nil;
    self.httpMethod = @"GET";
    self.headerFields = nil;
    self.postData = nil;
    self.service = nil;
    self.arguments = nil;
    self.secureConnection = NO;
    self.state = RS_NOTINITIALIZED;
    self.requestError = nil;
    self.queuePriority = NSOperationQueuePriorityVeryLow;

}

-(void)dealloc{

}

#pragma mark - setters

- (void)setMainUrl:(NSString *)mainUrl{
    if(mainUrl && mainUrl.length > 3){
        _mainUrl = mainUrl;
        self.state = RS_READY;
    } else {
        _mainUrl = nil;
        self.state = RS_NOTINITIALIZED;
    }
}

- (void)setHttpMethod:(NSString *)httpMethod{
    //TODO: check is valid
    _httpMethod = [httpMethod uppercaseString];
}

#pragma mark - request methods

-(SMrError*) requestWithCompletion:(SMRequestCompletionBlock) completion{
    if(self.state == RS_NOTINITIALIZED){
        // currently, only reason for uninitialized state is lack of mainUrl
        if(!self.mainUrl || self.mainUrl.length < 4) {
            SMrError * ret = [SMrError new];
            ret.errorType = ET_FAILED;
            ret.errorDescription = @"mainUrl must exist";
            ret.errorData = @{INVALID_ARGUMENT:[NSArray arrayWithObject:@"mainUrl"]};
            return ret;
        }
    }
    
    self.requestError = nil;
    self.requestCompletionBlock = completion;
    
    self.receivedData = nil;
    self.dataType = nil;
    self.statusCode = 0;
    
    
    [[SMrRequest sharedQueue] addOperation:self];
    self.state = RS_REQUESTED;
    
    return nil;
}

-(void) _startConnection{
    
    self.state = RS_WAITINGFORRESPONSE;
    NSMutableURLRequest * request = [self generateURLRequest];
    
//    self.receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    __block SMrRequest * localSelfCopy = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[SMrRequest sharedQueue] completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err){
        
        localSelfCopy.receivedData = data;
        
        if(err){
            if(!localSelfCopy.requestError) localSelfCopy.requestError = [SMrError new];
            [localSelfCopy.requestError addDataWithKey:[CONNECTION_ERROR copy] andValue:err.userInfo];
            if(data){
                [localSelfCopy.requestError raiseTypeTo: ET_WARNING];
            } else {
                [localSelfCopy.requestError raiseTypeTo: ET_FAILED];
            }
        }
        
        if(resp){
            if([resp isKindOfClass:[NSHTTPURLResponse class]]){
                localSelfCopy.statusCode = [((NSHTTPURLResponse*)resp) statusCode];
            }
            
            localSelfCopy.dataType = [resp MIMEType];
        }
        localSelfCopy.state = RS_RESPONSERECEIVED;
        if(localSelfCopy.requestCompletionBlock){
            NSOperationQueue * mainQ = [NSOperationQueue mainQueue];
//            NSBlockOperation * bo = [NSBlockOperation blockOperationWithBlock:^{
//                localSelfCopy.requestCompletionBlock(localSelfCopy);
//            }];
//            
//            [mainQ addOperation:bo];
            [mainQ addOperationWithBlock:^(){
                _requestCompletionBlock(localSelfCopy);
            }];
        }
        
    }];
}

#pragma mark - public utility method

-(void) clearHeaderFields{
    self.headerFields = [NSMutableDictionary new];
}

-(void) addHeaderValue:(NSString*)value forField:(NSString*)field{
    if(!self.headerFields) self.headerFields = [NSMutableDictionary new];
    [self.headerFields setValue:value forKey:field];
}

-(void) clearPostData{
    self.postData = nil;
}

-(SMrError*) createPostDataFromJSONDict:(NSDictionary*)jsonObject{
    NSError * err;
    self.postData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&err];
    if(err){
        return [[SMrError alloc] initWithNSError:err];
    }
    
    return nil;
}

-(SMrError*) createPostDataFromJSONString:(NSString*)jsonObject{
    NSError * err;
    
    // this step is just for checking sintax of jsonObject string
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:[jsonObject dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    if(err){
        return [[SMrError alloc] initWithNSError:err];
    }
    if(!dict){
        SMrError * ret = [[SMrError alloc] init];
        ret.errorDescription = @"Couldn't parse text as json";
        ret.errorType = ET_FAILED;
        ret.errorData = nil;
        return ret;
    }
    
    return [self createPostDataFromJSONDict:dict];
}

#pragma mark - private utility methods
-(NSMutableURLRequest *) generateURLRequest{
    NSURL * url = [self generateURL];
    if(!url) return nil; //error is already filled
    
    NSMutableURLRequest * ret = [[NSMutableURLRequest alloc] initWithURL:url];
    
    ret.HTTPMethod = self.httpMethod;
    
    //set header fields
    if(self.headerFields && self.headerFields.count > 0){
        for(NSString * key in self.headerFields.allKeys){
            [ret addValue:[self.headerFields valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    //set post data
    if(self.postData){
        [ret setHTTPBody:self.postData];
    }
    
    return ret;
}

-(NSURL *) generateURL{
    NSString * urlString;
    if(self.secureConnection){
        urlString = @"https://";
    } else {
        urlString = @"http://";
    }
    //cleaning mainUrl
    NSString * newMainUrl = [self cleanMainUrl];
        if(newMainUrl){
            self.mainUrl = newMainUrl;
        } else {
            //error
            [self addPropertyToInvalid:@"mainUrl" asFailed:YES];
            return nil;
        }
    //... and adding it to urlString
    urlString = [urlString stringByAppendingString:newMainUrl];
    
    //cleaning service
    NSString * newService = [self cleanService];
    if(newService){
        //... and appending it if there is one
        urlString = [urlString stringByAppendingString:[@"/" stringByAppendingString:newService]];
        self.service = newService;
    } else {
        if(self.service && self.service.length > 0){
            //this deserve warning
            [self addPropertyToIgnoredWarning:@"service"];
        }
    }
    
    //generating and cleaning arguments
    NSString * arguments = [self generateAndCleanArguments];
    if(arguments){
        urlString = [urlString stringByAppendingString:arguments];
    } else {
        if(self.arguments && self.arguments.count > 1){
            //this deserve warning too
            [self addPropertyToIgnoredWarning:@"arguments"];
        }
    }
    
    return [NSURL URLWithString:urlString];
    

}

-(NSString*) cleanMainUrl{
    NSString * ret = [self.mainUrl lowercaseString];
    NSString * start = [ret substringToIndex:4];
    if([start isEqualToString:@"http"]){
        start = [ret substringToIndex:5];
        if([start isEqualToString:@"https"]){
            self.secureConnection = YES;
            ret = [ret substringFromIndex:8]; // skipping https://
        } else {
            self.secureConnection = NO;
            ret = [ret substringFromIndex:7]; // skipping http://
        }
    }
    
    NSRange range = [ret rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"] options: NSBackwardsSearch];
    if(range.location == ret.length - 1){
        ret = [ret substringToIndex:ret.length - 1];
    }
    if(ret.length < 3){
        ret = nil;
    }
    return [ret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*) cleanService{
    if(!self.service) return nil;
    NSString * ret = [self.service stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange range = [ret rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"] options: NSBackwardsSearch];
    if(range.location == ret.length - 1){
        //remove '/' from the end
        ret = [ret substringToIndex:ret.length - 1];
    }
    
    range = [ret rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"] options: 0];
    if(range.location == 0){
        //remove '/' from the begining
        ret = [ret substringFromIndex:1];
    }

    return ret;
}

-(NSString*)generateAndCleanArguments{
    if(!self.arguments || self.arguments.count < 1) return nil;

    NSString * ret = @"?";
    NSString * currArg;
    for (NSString * key in self.arguments.allKeys) {
        currArg = [NSString stringWithFormat:@"%@=%@&", key, [self.arguments valueForKey:key]];
        ret = [ret stringByAppendingString:currArg];
    }
//    remove last '&' and add percent escape
    ret = [[ret substringToIndex:ret.length - 1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return ret;
    
}

-(void) addPropertyToIgnoredWarning:(NSString*)propName{
    if(!self.requestError) self.requestError = [SMrError new];
    [self.requestError raiseTypeTo:ET_WARNING];
    [self.requestError addDataToArrayWithKey:IGNORED_ARGUMENT andValue:propName];
}

-(void) addPropertyToInvalid:(NSString*)propName asFailed:(BOOL)failed{
    if(!self.requestError) self.requestError = [SMrError new];
    if(failed)[self.requestError raiseTypeTo:ET_FAILED];
    else [self.requestError raiseTypeTo:ET_WARNING];
    if(failed) self.requestError.errorDescription = [NSString stringWithFormat:@"%@ is invalid", propName];
    [self.requestError addDataToArrayWithKey:INVALID_ARGUMENT andValue:@"mainUrl"];
}



#pragma mark - static

+(NSOperationQueue*) sharedQueue{
    static NSOperationQueue * sRequestQueue;
    
    if(!sRequestQueue){
        sRequestQueue = [NSOperationQueue new];
        sRequestQueue.maxConcurrentOperationCount = MAX_CONCURENTREQUESTS;
    }
    
    return sRequestQueue;
}

@end
