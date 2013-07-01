//
//  SMCyMenuController.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"
#import "SMCyMenu.h"

@interface SMCyMenuController : SMCyBaseVC

@property(nonatomic) id<SMCyMenuDelegate> delegate;

-(void) switchToUserMenu;
-(void) switchToMapMenu;


@end
