//
//  SMCykelRoute.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCyLocation.h"
#import "SMrError.h"

typedef enum _eRouteState {
    RS_UNKNOWN,
    RS_SEARCHING_FOR_ROUTE,
    RS_FAILED_SEARCHING_FOR_ROUTE,
    RS_READY
} eRouteState;

@class SMCyRoute;

@protocol SMCyRouteDelegate <NSObject>
-(void)routeStateChanged:(SMCyRoute*)route;
@end

@interface SMCyRoute : NSObject{
@protected
    SMCyLocation * _start;
    SMCyLocation * _end;
    eRouteState _state;
    SMrError * _error;
}
@property(nonatomic, readonly) SMCyLocation * start;
@property(nonatomic, readonly) SMCyLocation * end;
@property(nonatomic, readonly) SMrError * error;
@property(nonatomic, readonly) eRouteState state;
@property(nonatomic, weak) id<SMCyRouteDelegate> delegate;
@end
