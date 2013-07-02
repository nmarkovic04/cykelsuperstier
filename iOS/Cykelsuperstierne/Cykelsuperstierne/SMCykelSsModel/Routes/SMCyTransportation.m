//
//  SMCyTransportation.m
//  Cykelsuperstierne
//
//  Created by Rasko on 7/2/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyTransportation.h"
#import "SMCyTransportationLine.h"
#import "SMrUtil.h"

@interface SMCyTransportation()
@property(nonatomic, strong, readwrite) NSArray * lines;
@end

@implementation SMCyTransportation
-(void) loadDummyData{
    NSString * filePath0 = [[NSBundle mainBundle] pathForResource:@"Albertslundruten" ofType:@"line"];
    NSString * filePath1 = [[NSBundle mainBundle] pathForResource:@"Farumruten" ofType:@"line"];
    SMCyTransportationLine * line0 = [[SMCyTransportationLine alloc] initWithFile:filePath0];
    SMCyTransportationLine * line1 = [[SMCyTransportationLine alloc] initWithFile:filePath1];
//    NSMutableArray * arr = [NSMutableArray new];
//    [arr addObject:line0];
//    [arr addObject:line1];
    self.lines = @[line0,line1];
}

+(SMCyTransportation*)sharedInstance{
    static SMCyTransportation * sharedInstance = nil;
    if(!sharedInstance){
        sharedInstance = [SMCyTransportation new];
#warning change this
        [sharedInstance loadDummyData];
    }
    return sharedInstance;
}
@end
