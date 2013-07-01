//
//  SMCyMainMapVC.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"
#import "SMCyMenu.h"

@class SMCyMenuController;


@interface SMCyMainMapVC : SMCyBaseVC<SMCyMenuDelegate>{
@protected
    float _openedMenuPosition;
    float _closedMenuPosition;
    BOOL _isActiveMenuMAP;
    BOOL _isActiveStateOpeningMenu;
    BOOL _isMenuClosed;
    float _startPanningPosition;
    UITapGestureRecognizer * _mainTap;
    UIPanGestureRecognizer * _mainPan;
    SMCyMenuController * _menuVC;
}
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *mainViewContainer;

@property (weak, nonatomic) IBOutlet UIView *userMenuHandle;
@property (weak, nonatomic) IBOutlet UIView *mapMenuHandle;
@property (strong, nonatomic, readonly) SMCyMenuController * menuVC;


@end
