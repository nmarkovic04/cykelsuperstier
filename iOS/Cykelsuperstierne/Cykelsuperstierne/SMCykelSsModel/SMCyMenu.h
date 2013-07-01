//
//  SMCyMenu.h
//  Cykelsuperstierne
//
//  Created by Rasko on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"

@class SMCyMenu;

@protocol SMCyMenuDelegate

-(void)mapMenuSelectionChanged:(SMCyMenu*)menu;

-(void)userMenuDidAddNewFavorite:(SMCyMenu*)menu;
-(void)userMenuProfileClicked:(SMCyMenu*)menu;
-(void)userMenuAboutClicked:(SMCyMenu*)menu;

@end


//this is meant to be used as a menu notification center
@interface SMCyMenu : SMCyBaseVC

@property(nonatomic, weak) id<SMCyMenuDelegate> delegate;

-(void)notifyDelegateMapSelectionChanged;
-(void)notifyDelegateDidAddNewFavorite;
-(void)notifyDelegateProfileClicked;
-(void)notifyDelegateAboutClicked;

+(SMCyMenu*)sharedInstance;


@end
