//
//  SMCySearchHistory.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCySearchHistoryEntity.h"
@interface SMCySearchHistory : NSObject
+(SMCySearchHistory*)instance;

-(BOOL)load;
-(BOOL)save;

-(void)addSearchEntity:(SMCySearchHistoryEntity*)entity;
-(void)addSearchEntityWithLocation:(SMCyLocation*)location;
-(NSArray*)entities;
@end
