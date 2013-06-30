//
//  SMCyFavorites.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyLocation.h"
@class SMCyFavoritePlace;

@interface SMCyFavorites : SMCyLocation

@property(nonatomic, strong) SMCyFavoritePlace * home;
@property(nonatomic, strong) SMCyFavoritePlace * work;
@property(nonatomic, strong) SMCyFavoritePlace * school;
@property(nonatomic, strong, readonly) NSArray * favorites;

-(BOOL) addFavoritePlace:(SMCyFavoritePlace*)favorite;
-(BOOL) removeFavoritePlace:(SMCyFavoritePlace*)favorite;

-(void) reload;


@end
