//
//  SMCyFavouritesTableViewController.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCyRouteDestinationDelegate.h"

@interface SMCyFavouritesTableViewController : UITableViewController

@property(nonatomic,weak) id<SMCyRouteDestinationDelegate> destinationDelegate;
-(void)setup;

@end
