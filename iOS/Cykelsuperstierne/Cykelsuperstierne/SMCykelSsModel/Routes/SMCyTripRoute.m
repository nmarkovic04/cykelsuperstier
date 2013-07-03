//
//  SMCykelTripRoute.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyTripRoute.h"
#import "SMCyTransportation.h"
#import "SMCyTransportationLine.h"
#import "SMrUtil.h"
#import "SMCyBrokenRouteInfo.h"
@interface SMCyTripRoute()
@property(nonatomic, strong, readwrite) NSMutableArray * internalRoutes;
@end

@implementation SMCyTripRoute{
    NSBlockOperation* searchingOperation;
}

-(BOOL)isIsValid{
    return (self.routes && self.routes.count > 0);
}

-(id) initWithStart:(SMCyLocation*)start end:(SMCyLocation*)end andDelegate:(id<SMCyRouteDelegate>)delegate{
    self = [super init];
    
    if(self){
        self.delegate = delegate;
        [self setStart:start andEnd:end];
    }
    SMCyTransportation * temp = [SMCyTransportation sharedInstance];
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

-(BOOL) breakRoute{
    if(self.routes.count==0)
        return NO;
    
    if(self.state == RS_SEARCHING_FOR_ROUTE){
        [searchingOperation cancel];
        searchingOperation= nil;
    }
    
    __weak SMCyTripRoute* selfRef= self;
    self.state= RS_SEARCHING_FOR_ROUTE;
    
    searchingOperation= [NSBlockOperation blockOperationWithBlock:^{
        [selfRef breakRouteInBackground];
    }];

    searchingOperation.completionBlock= ^{
        //todo Change state
        selfRef.state= RS_READY;
        [selfRef.delegate routeStateChanged:selfRef];
    };
    
    [[SMCyRoute routeQueue] addOperation:searchingOperation];
    
    return YES;
}

-(void)breakRouteInBackground{
    SMCyLocation* start= [self start];
    SMCyLocation* end= [self end];
    NSMutableArray* brokenRoutesTemp= [NSMutableArray new];
    double currentDistance= [start.location distanceFromLocation:end.location];
    
    NSArray* lines= [SMCyTransportation sharedInstance].lines;
    
    for( SMCyTransportationLine* transportationLine in lines){
        double toA= 0;
        double toB= 0;
        NSMutableArray* startDistances= [NSMutableArray new];
        NSMutableArray* endDistances= [NSMutableArray new];
        for(SMCyLocation* stationLocation in transportationLine.stations){
            toA= [stationLocation.location distanceFromLocation:start.location];
            toB= [stationLocation.location distanceFromLocation:end.location];
            
            if(toA < currentDistance){
                stationLocation.distance0= MK_DOUBLE(toA);
                [startDistances addObject:stationLocation];
            }
            
            if(toB < currentDistance){
                stationLocation.distance1= MK_DOUBLE(toB);
                [endDistances addObject:stationLocation];
            }
        }
        
        [startDistances sortedArrayUsingComparator:^(id obj1, id obj2) {
            SMCyLocation* distance1= obj1;
            SMCyLocation* distance2= obj2;
            
            if(distance1.distance0.doubleValue <distance2.distance0.doubleValue){
                return (NSComparisonResult)NSOrderedAscending;
            }else{
                return (NSComparisonResult) NSOrderedDescending;
            }
            
        }];
        
        [endDistances sortedArrayUsingComparator:^(id obj1, id obj2) {
            SMCyLocation* distance1= obj1;
            SMCyLocation* distance2= obj2;
            
            if(distance1.distance1.doubleValue <distance2.distance1.doubleValue){
                return (NSComparisonResult)NSOrderedAscending;
            }else{
                return (NSComparisonResult) NSOrderedDescending;
            }
            
        }];
        
        SMCyBrokenRouteInfo* brokenRouteInfo= [SMCyBrokenRouteInfo new];
        
        brokenRouteInfo.startingStationsSorted= startDistances;
        brokenRouteInfo.endingStationsSorted= endDistances;
        brokenRouteInfo.transportationLine= transportationLine;
        
        NSLog(@"startDistances %@",startDistances);
        NSLog(@"endDistances %@",endDistances);        
        [brokenRoutesTemp addObject:brokenRouteInfo];
    }
    
    self.brokenRoutes= [NSArray arrayWithArray:brokenRoutesTemp];

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

-(SMCyLocation *)start{
    if(self.routes.count>0)
        return ((SMCyRoute*)[self.routes objectAtIndex:0]).start;
    
    return nil;
}

-(SMCyLocation *)end{
    if(self.routes.count>0)
        return ((SMCyRoute*)[self.routes lastObject]).end;
    
    return nil;
}
@end
