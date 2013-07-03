//
//  SMCySearchHistoryEntity.m
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySearchHistoryEntity.h"

@implementation SMCySearchHistoryEntity

-(id)initWithLocation:(SMCyLocation*)pLocation{
    if(self= [super init]){
        self.location= pLocation;
        self.timeOfSearch= [NSDate new];
    }
    return self;
}

-(id)initWithLocation:(SMCyLocation*)location time:(NSDate*) time{
    if (self= [super init]) {
        self.location= location;
        self.timeOfSearch= time;
    }
    return self;
}
@end
