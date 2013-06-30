//
//  SMCyFavorites.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyFavorites.h"
@interface SMCyFavorites(){
    NSMutableArray * _favorites;
}
@end

@implementation SMCyFavorites

- (NSArray *)favorites{
    if(!_favorites){
        _favorites = [NSMutableArray new];
    }
    
    return _favorites;
}

-(BOOL) addFavoritePlace:(SMCyFavoritePlace*)favorite{
    return NO;
}

-(BOOL) removeFavoritePlace:(SMCyFavoritePlace*)favorite{
    return NO;    
}


-(void) reload{
    
}

@end
