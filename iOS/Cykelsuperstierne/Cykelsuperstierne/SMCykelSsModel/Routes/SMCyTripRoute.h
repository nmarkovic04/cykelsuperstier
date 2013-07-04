//
//  SMCykelTripRoute.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRoute.h"
#import "SMCyBikeRoute.h"
#import "SMCyTransportationRoute.h"

@interface SMCyTripRoute : SMCyRoute<SMCyRouteDelegate>{
 
}

@property(nonatomic, readonly) BOOL isValid;
@property(nonatomic, strong, readonly) NSArray * routes;
@property(nonatomic, strong) NSArray* brokenRoutes; // array of SMCyBrokenRouteInfo

-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>)delegate;
-(void) setStart:(SMCyLocation*)start andEnd:(SMCyLocation*)end;
-(BOOL) breakRoute;

@end
