//
//  SMCyMainMapVC+Animations.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMainMapVC.h"

@interface SMCyMainMapVC (Animations)

@property(nonatomic, strong) UITapGestureRecognizer * mainTap;
@property(nonatomic, strong) UIPanGestureRecognizer * mainPan;
@property(nonatomic) BOOL isActiveMenuMAP;

-(void) onUserMenuHandlePan:(UIPanGestureRecognizer*)sender;
-(void) onUserMenuHandleTap:(UITapGestureRecognizer*)sender;
-(void) onMapMenuHandlePan:(UIPanGestureRecognizer*)sender;
-(void) onMapMenuHandleTap:(UITapGestureRecognizer*)sender;
-(void) onMainViewTap:(UITapGestureRecognizer*)sender;
-(void) onMainViewPan:(UIPanGestureRecognizer*)sender;
-(void) panViewFor:(float)offset;
-(void)initializeOpenCloseStates;
-(BOOL)openMenuWithEaseIn:(BOOL)easeIn;
-(BOOL)closeMenuWithEaseIn:(BOOL)easeIn;
-(float) getCurrentMainViewPosition;
@end
