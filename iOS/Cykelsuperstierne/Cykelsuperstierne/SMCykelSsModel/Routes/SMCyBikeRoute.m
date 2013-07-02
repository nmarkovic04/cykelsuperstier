//
//  SMCykelBikeRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBikeRoute.h"
#import "SMRequestOSRM.h"
#import "SMGPSUtil.h"



@interface SMCyBikeRoute()
@property(nonatomic, strong) SMRequestOSRM * osrmRequest;
@property(nonatomic, strong, readwrite) NSArray * waypoints;
@property(nonatomic, strong, readwrite) NSArray * turnInstructions;

@end

@implementation SMCyBikeRoute
-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>) delegate{
    self = [super init];
    if(self){
        self.delegate = delegate;
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
    [self prepareRouteFromJSON:res];
}

- (void)request:(SMRequestOSRM*)req failedWithError:(NSError*)error{
    self.error = [[SMrError alloc] initWithNSError:error];
    self.state = RS_FAILED_SEARCHING_FOR_ROUTE;    
}

- (void)serverNotReachable{
    [self failedWithError:@"serverNotReachable"];
}

-(void) failedWithError:(NSString*)err{
    self.error = [SMrError new];
    self.error.errorType = ET_FAILED;
    self.error.errorDescription = err;
    self.state = RS_FAILED_SEARCHING_FOR_ROUTE;
}

#pragma mark - 

-(void) prepareRouteFromJSON:(NSDictionary*)jsonDict{
    NSBlockOperation * bo = [NSBlockOperation blockOperationWithBlock:^{
        [self backPreparationWithJSON:jsonDict];
    }];
    
    __weak SMCyBikeRoute * selfRef = self;
    bo.completionBlock = ^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(!selfRef.waypoints || selfRef.waypoints.count == 0){
                [selfRef failedWithError:@"routeNotFound"];
            } else {
                selfRef.state = RS_READY;
            }
        }];
    };
    
    [[SMCyRoute routeQueue] addOperation:bo];
}

-(void)backPreparationWithJSON:(NSDictionary*)jsonDict{
    
    if(!jsonDict || ![jsonDict isKindOfClass:[NSDictionary class]]){
        [self resetData];
        return;
    }
    self.name = [self stringFromNSObject:[jsonDict valueForKey:@"route_name"]];
    NSDictionary * summary = [jsonDict valueForKey:@"route_summary"];
    if(summary){
        
        self.startName = [self stringFromNSObject:[summary valueForKey:@"start_point"]];
        self.endName = [self stringFromNSObject:[summary valueForKey:@"end_point"]];
        self.distance = [summary valueForKey:@"total_distance"];
        self.ridingTime = [summary valueForKey:@"total_time"];
    }
    
    NSArray * turnInst = [jsonDict valueForKey:@"route_instructions"];
    if(turnInst) [self initializeTurnInstructionsFrom:turnInst];
    
    self.waypoints = [SMGPSUtil decodePolyline:[jsonDict valueForKey:@"route_geometry"]];
    [self convertWaypointsFromCLLocations2SMCyLocations];
    bool test = true;
}

-(void) initializeTurnInstructionsFrom:(NSArray*)instructions{
    self.turnInstructions = nil;
    if(![instructions isKindOfClass:[NSArray class]]) return;
    NSMutableArray * turnInstructions = [NSMutableArray new];
    SMCyTurnInstruction * turnInst;
    for(NSArray * inst in instructions){
        turnInst = [[SMCyTurnInstruction alloc] initWithArray:inst];
        if(turnInst) [turnInstructions addObject:turnInst];
    }
    self.turnInstructions = turnInstructions;
}

-(NSString*) stringFromNSObject:(NSObject*)obj{
    if([obj isKindOfClass:[NSString class]]) return (NSString*)obj;
    
    NSString * ret = nil;
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray * arr = (NSArray*)obj;
        if(arr.count > 0){
            ret = ((NSObject*)[arr objectAtIndex:0]).description;
            for(int i = 1 ; i < arr.count; ++i){
                ret = [ret stringByAppendingFormat:@", %@", ((NSObject*)[arr objectAtIndex:i]).description];
            }
        }
        return ret;
    }
    return nil;
}

-(void) resetData{
    self.waypoints = nil;
    self.name = nil;
    self.startName = nil;
    self.endName = nil;
    self.turnInstructions = nil;
}

-(void) convertWaypointsFromCLLocations2SMCyLocations{
    NSMutableArray * arr = [NSMutableArray new];
    SMCyLocation * cyLoc;
    for(CLLocation * loc in self.waypoints){
        cyLoc = [SMCyLocation new];
        cyLoc.location = loc;
        [arr addObject:cyLoc];
    }
    
    self.waypoints = arr;
}

#pragma mark - static



@end
