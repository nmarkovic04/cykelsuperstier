//
//  SMCykelBikeRoute.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRoute+Protected.h"
#import "SMRequestOSRM.h"
#import "SMCyTurnInstruction.h"

@interface SMCyBikeRoute : SMCyRoute <SMRequestOSRMDelegate>
@property(nonatomic, strong, readonly) NSArray * waypoints;
@property(nonatomic, strong, readonly) NSArray * turnInstructions;

-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>) delegate;
-(void) setStart:(SMCyLocation*)start andEnd:(SMCyLocation*)end;
@end
