//
//  SMCykelTripRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyTripRoute.h"
@interface SMCyTripRoute()
@property(nonatomic, strong, readwrite) NSMutableArray * internalRoutes;
@end

@implementation SMCyTripRoute
-(BOOL)isIsValid{
    return (self.routes && self.routes.count > 0);
}

-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>)delegate{
    self = [super init];
    
    if(self){
        self.delegate = delegate;
        [self setStart:start andEnd:end];
    }
    
    return self;
}

-(NSArray *)routes{
    return self.internalRoutes;
}

-(void) setStart:(SMCyLocation*)start andEnd:(SMCyLocation*)end{
    self.state = RS_SEARCHING_FOR_ROUTE;
    self.internalRoutes = [NSMutableArray new];
    [self.internalRoutes addObject:[[SMCyBikeRoute alloc] initWithStart:start end:end andDelegate:self]];
}

-(void) breakRoute{
#warning unfinished method
}

#pragma mark child notifications

-(void)routeStateChanged:(SMCyRoute *)route{
    BOOL isReady = YES;
    if(route.state != RS_READY){
        for(SMCyRoute * child in self.routes){
            if(child.state != RS_READY) {
                isReady = NO;
             break;
            }
        }
    }
    if(isReady) self.state = RS_READY;
}

@end
