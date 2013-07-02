//
//  SMCykelRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRoute+Protected.h"
#import "SMrUtil.h"

#define MAX_CONCURENT_ROUTE_THREADS 4

@implementation SMCyRoute (Protected)
- (void)setState:(eRouteState)state{
    if(state == _state) return;
    _state = state;
    [SMrUtil notifyOnMainThreadDelegate:self.delegate WithSelector:@selector(routeStateChanged:) AndObject:self];
}
- (void)setError:(SMrError*)error{
    _error = error;
}

- (void)setName:(NSString*)name{
    _name = name;
}

- (void)setStartName:(NSString*)startName{
    _startName = startName;
}

- (void)setEndName:(NSString*)endName{
    _endName = endName;
}

- (void)setDistance:(NSNumber*)distance{
    _distance = distance;
}

- (void)setRidingTime:(NSNumber*)ridingTime{
    _ridingTime = ridingTime;
}

+(NSOperationQueue*) routeQueue{
    static NSOperationQueue * sRequestQueue;
    
    if(!sRequestQueue){
        sRequestQueue = [NSOperationQueue new];
        sRequestQueue.maxConcurrentOperationCount = MAX_CONCURENT_ROUTE_THREADS;
    }
    
    return sRequestQueue;
}
@end

@implementation SMCyRoute
- (id)init{
    self= [super init];
    if(self){
        _state = RS_UNKNOWN;
        _error = nil;
    }
    return self;
}

- (eRouteState)state{
    return _state;
}

- (SMrError *)error{
    return _error;
}

- (NSString *)name{
    return  _name;
}

-(NSString *)startName{
    return _startName;
}

-(NSString *)endName{
    return _endName;
}

- (NSNumber *)distance{
    return _distance;
}

-(NSNumber *)ridingTime{
    return _ridingTime;
}
@end
