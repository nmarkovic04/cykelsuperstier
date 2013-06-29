//
//  SMySlideHandleView.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/29/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _eDirections {
    DIR_VERTICAL,
    DIR_HORIZONTAL,
    DIR_UNKNOWN
} eDirections;

@interface SMrLinkedSlideViewData : NSObject

-(id) initWithLayerFromView:(UIView*)view startValue:(float)start endValue:(float)end andKeyPath:(NSString*) keyPath;
-(void) setStartValue:(float)start andEndValue:(float)end;
-(void) insertValue:(float) val atIndex:(int)index;
-(void) addPoint:(float) val;



@property(nonatomic, strong) CALayer * linkedLayer;
@property(nonatomic, strong) NSString * keyPath;

@end

@interface SMrSlideHandleView : UIView<UIGestureRecognizerDelegate>

-(id) initWithStartPos:(float)start andEndPos:(float)end lockedDirection:(eDirections) direction;
-(id) initWithStartPos:(float)start endPos:(float)end andLinkedViews:(NSArray*) slideViewDataArray;

-(void) addLinkedView:(SMrLinkedSlideViewData*)linkedView;
-(void) setStart:(float)start andEnd:(float)end;
-(void) addPosition:(float) position;

-(void) reset;


@property(nonatomic) eDirections lockedDirection;
@property(nonatomic, readonly) NSString * keyPath;

@end
