//
//  SMCyRouteDestinationDelegate.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCyLocation.h"

@protocol SMCyRouteDestinationDelegate <NSObject>

-(void)didSelectDestinationWithLocation:(SMCyLocation*)location;
@end
