//
//  SMCyTransportationLine.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyTransportationLine.h"
#import "SMCyLocation.h"

@interface SMCyTransportationLine()
@property(nonatomic, strong, readwrite) NSArray * stations;
@property(nonatomic, strong, readwrite) NSString * name;
@end

@implementation SMCyTransportationLine
-(id) initWithFile:(NSString*)filePath{
    self = [super init];
    if(self){
        [self loadFromFile:filePath];
    }
    return self;
}

-(void) loadFromFile:(NSString*)filePath{
    NSError * err;
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    self.name = [dict valueForKey:@"name"];
    NSArray * coord = [dict valueForKey:@"coordinates"];
    NSNumber * lon;
    NSNumber * lat;
    SMCyLocation * location;
    NSMutableArray * stations = [NSMutableArray new];
    for(NSArray * arr in coord){
        lon = [arr objectAtIndex:0];
        lat = [arr objectAtIndex:1];
        location = [[SMCyLocation alloc] init];
        location.longitude = lon;
        location.latitude = lat;
        [stations addObject:location];
    }
    self.stations = stations;
}

@end
