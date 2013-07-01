//
//  SMCykelBikeRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBikeRoute.h"
#import "SMRequestOSRM.h"

@interface SMCyBikeRoute()
@property(nonatomic, strong) SMRequestOSRM * osrmRequest;
@end

@implementation SMCyBikeRoute
-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>) delegate{
    self = [super init];
    if(self){
        
        [self setStart:start andEnd:end];
    }
    return self;
}
-(void) setStart:(SMCyLocation*)start andEnd:(SMCyLocation*)end{
    self.state = RS_SEARCHING_FOR_ROUTE;
    _start = start;
    _end = end;
    self.osrmRequest = [[SMRequestOSRM alloc] initWithDelegate:self];
    self.osrmRequest.osrmServer = OSRM_SERVER;
    [self.osrmRequest getRouteFrom:self.start.location2DCoord to:self.end.location2DCoord via:nil];
}

#pragma mark - SMRequestOSRMDelegate methods
- (void)request:(SMRequestOSRM*)req finishedWithResult:(id)res{
    self.state = RS_READY;
    bool test = true;
}

- (void)request:(SMRequestOSRM*)req failedWithError:(NSError*)error{
    self.error = [[SMrError alloc] initWithNSError:error];
    self.state = RS_FAILED_SEARCHING_FOR_ROUTE;    
}

- (void)serverNotReachable{
    self.error = [SMrError new];
    self.error.errorType = ET_FAILED;
    self.error.errorDescription = @"serverNotReachable";
    self.state = RS_FAILED_SEARCHING_FOR_ROUTE;
}
@end
