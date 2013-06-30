//
//  SMCyMainMapVC+Animations.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMainMapVC+Animations.h"
#import <QuartzCore/QuartzCore.h>
#import "SMrUtil.h"
#import "SMCyMenuController.h"

@implementation SMCyMainMapVC (Animations)

#pragma mark - setters / getters

-(UIPanGestureRecognizer *)mainPan{
    return _mainPan;
}

- (void)setMainPan:(UIPanGestureRecognizer *)mainPan{
    _mainPan = mainPan;
}
-(UITapGestureRecognizer *)mainTap{
    return _mainTap;
}

-(void)setMainTap:(UITapGestureRecognizer *)mainTap{
    _mainTap = mainTap;
}

- (BOOL)isActiveMenuMAP{
    return _isActiveMenuMAP;
}

- (void)setIsActiveMenuMAP:(BOOL)isActiveMenuMAP{
    _isActiveMenuMAP = isActiveMenuMAP;
    if(_menuVC){
        if(isActiveMenuMAP){
            [_menuVC switchToMapMenu];
        } else{
            [_menuVC switchToUserMenu];
        }
    }
}

#pragma mark - 
-(void) onUserMenuHandlePan:(UIPanGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        _startPanningPosition = [self getCurrentMainViewPosition];
        if(_isMenuClosed){
            self.isActiveMenuMAP = NO;
        }
    } else if(sender.state == UIGestureRecognizerStateEnded){
        if([sender velocityInView:self.mainViewContainer].x > 0){
            //opening
            [self openMenuWithEaseIn:NO];
        } else {
            //closing
            [self closeMenuWithEaseIn:NO];
        }
        return;
    }
    
    [self panViewFor:[sender translationInView:self.mainViewContainer].x];
}
-(void) onUserMenuHandleTap:(UITapGestureRecognizer*)sender{
    //do whatever is appropriate
    if([self openMenuWithEaseIn:YES]){
        self.isActiveMenuMAP = NO;
    } else {
        [self closeMenuWithEaseIn:YES];
    }
    
}
-(void) onMapMenuHandlePan:(UIPanGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        _startPanningPosition = [self getCurrentMainViewPosition];
        if(_isMenuClosed){
            self.isActiveMenuMAP = YES;
        }
    } else if(sender.state == UIGestureRecognizerStateEnded){
        if([sender velocityInView:self.mainViewContainer].x > 0){
            //opening
            [self openMenuWithEaseIn:NO];
        } else {
            //closing
            [self closeMenuWithEaseIn:NO];
        }
        return;
    }
    
    [self panViewFor:[sender translationInView:self.mainViewContainer].x];
}
-(void) onMapMenuHandleTap:(UITapGestureRecognizer*)sender{
    //do whatever is appropriate
    if([self openMenuWithEaseIn:YES]){
        self.isActiveMenuMAP = YES;
    } else {
        [self closeMenuWithEaseIn:YES];
    }
}

-(void) onMainViewTap:(UITapGestureRecognizer*)sender{
    [self closeMenuWithEaseIn:YES];
}

-(void) onMainViewPan:(UIPanGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        _startPanningPosition = [self getCurrentMainViewPosition];
    } else if(sender.state == UIGestureRecognizerStateEnded){
        if([sender velocityInView:self.mainViewContainer].x > 0){
            //opening
            [self openMenuWithEaseIn:NO];
        } else {
            //closing
            [self closeMenuWithEaseIn:NO];
        }
        return;
    }
    
    [self panViewFor:[sender translationInView:self.mainViewContainer].x];
}

-(void) panViewFor:(float)offset{
    CGPoint pos =  self.mainViewContainer.layer.position;
    pos.x = _startPanningPosition + offset;
    _isMenuClosed = NO;
    if(pos.x > _openedMenuPosition) {
        [self.mainTap setEnabled:YES];
        [self.mainPan setEnabled:YES];
        pos.x = _openedMenuPosition;
    }
    else if(pos.x < _closedMenuPosition) {
        [self.mainTap setEnabled:NO];
        [self.mainPan setEnabled:NO];
        pos.x = _closedMenuPosition;
        _isMenuClosed = NO;
    }
    self.mainViewContainer.layer.position = pos;
}

-(void)initializeOpenCloseStates{
    self.mainViewContainer.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.mainViewContainer.layer.position = CGPointMake(0.0, 0.0);
    _openedMenuPosition = self.menuContainer.bounds.size.width;
    _closedMenuPosition = 0.0;
    
    UITapGestureRecognizer * mapHTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMapMenuHandleTap:)];
    UIPanGestureRecognizer * mapHPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMapMenuHandlePan:)];
    
    UITapGestureRecognizer * userHTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserMenuHandleTap:)];
    UIPanGestureRecognizer * userHPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onUserMenuHandlePan:)];
    
    [self.mapMenuHandle addGestureRecognizer:mapHTap];
    [self.mapMenuHandle addGestureRecognizer:mapHPan];
    
    [self.userMenuHandle addGestureRecognizer:userHTap];
    [self.userMenuHandle addGestureRecognizer:userHPan];
    
    self.mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMainViewTap:)];
    [self.mainViewContainer addGestureRecognizer:self.mainTap];
    
    self.mainPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMainViewPan:)];
    [self.mainViewContainer addGestureRecognizer:self.mainPan];
    
    [self.mainTap setEnabled:NO];
    [self.mainPan setEnabled:NO];
    
    
    self.isActiveMenuMAP = YES;
    _isActiveStateOpeningMenu = YES;
    _isMenuClosed = YES;
    
}

-(BOOL)openMenuWithEaseIn:(BOOL)easeIn{
    
    float currentPos = [self getCurrentMainViewPosition];
    if(currentPos >= _openedMenuPosition) return NO;
    CGPoint pos =  self.mainViewContainer.layer.position;
    pos.x = _openedMenuPosition;
    self.mainViewContainer.layer.position = pos;
    float time = (_openedMenuPosition - currentPos) * 0.0005;
    
    CABasicAnimation * anim =[CABasicAnimation animationWithKeyPath:@"position.x"];
    anim.fromValue = MK_FLOAT(currentPos);
    anim.toValue = MK_FLOAT(_openedMenuPosition);
    if(easeIn){
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    } else {
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    anim.removedOnCompletion = YES;
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:time];
    [self.mainViewContainer.layer addAnimation:anim forKey:@"open"];
    [CATransaction commit];
    
    _isMenuClosed = NO;
    [self.mainTap setEnabled:YES];
    [self.mainPan setEnabled:YES];
    return YES;
    
}

-(BOOL)closeMenuWithEaseIn:(BOOL)easeIn{
    float currentPos = [self getCurrentMainViewPosition];
    if(currentPos <= _closedMenuPosition) return NO;
    CGPoint pos =  self.mainViewContainer.layer.position;
    pos.x = _closedMenuPosition;
    self.mainViewContainer.layer.position = pos;
    float time = (currentPos - _closedMenuPosition) * 0.0005;
    
    CABasicAnimation * anim =[CABasicAnimation animationWithKeyPath:@"position.x"];
    anim.fromValue = MK_FLOAT(currentPos);
    anim.toValue = MK_FLOAT(_closedMenuPosition);
    if(easeIn){
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    } else {
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    anim.removedOnCompletion = YES;
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:time];
    [self.mainViewContainer.layer addAnimation:anim forKey:@"open"];
    [CATransaction commit];
    
    _isMenuClosed = YES;
    [self.mainTap setEnabled:NO];
    [self.mainPan setEnabled:NO];
    return YES;
}

-(float) getCurrentMainViewPosition{
    return [[self.mainViewContainer.layer.presentationLayer valueForKeyPath:@"position.x"] floatValue];
}
@end
