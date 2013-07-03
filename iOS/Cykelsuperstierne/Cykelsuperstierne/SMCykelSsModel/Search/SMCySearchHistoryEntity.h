//
//  SMCySearchHistoryEntity.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCyLocation.h"
@interface SMCySearchHistoryEntity : NSObject

-(id)initWithLocation:(SMCyLocation*)location;
-(id)initWithLocation:(SMCyLocation*)location time:(NSDate*) time;
@property(strong, nonatomic) NSDate* timeOfSearch;
@property(strong, nonatomic) SMCyLocation* location;

@end
