//
//  SMCykelRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRoute+Protected.h"
#import "SMrUtil.h"

@implementation SMCyRoute (Protected)
- (void)setState:(eRouteState)state{
    if(state == _state) return;
    _state = state;
    [SMrUtil notifyOnMainThreadDelegate:self.delegate WithSelector:@selector(routeStateChanged:) AndObject:self];
}
- (void)setError:(SMrError*)error{
    _error = error;
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

@end
