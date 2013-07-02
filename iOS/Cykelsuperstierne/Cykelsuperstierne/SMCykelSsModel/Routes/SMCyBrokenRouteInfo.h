//
//  SMCyBrokenRouteInfo.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/2/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCyTransportationLine.h"
@interface SMCyBrokenRouteInfo : NSObject

@property(nonatomic, strong) NSArray* startingStationsSorted;
@property(nonatomic, strong) NSArray* endingStationsSorted;
@property(nonatomic, strong) SMCyTransportationLine* transportationLine;

@end
