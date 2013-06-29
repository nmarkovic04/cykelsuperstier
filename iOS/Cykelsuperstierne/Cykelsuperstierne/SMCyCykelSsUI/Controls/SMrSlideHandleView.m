//
//  SMySlideHandleView.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/29/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrSlideHandleView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_TIMING_FUNCTION [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]
#define GRAVITY 1000.0

@interface _ValueSegment : NSObject{
@public
    float _coeff;
    float _start;
}

@property(nonatomic, readonly) float coeff;
@property(nonatomic, readonly) float start;


-(id) initWithStart:(float)start andEnd:(float)end;
-(void) setStart:(float)start andEnd:(float)end;
-(BOOL) isValInside:(float)val;
-(float) getValueOn:(float)normalizedPosition;
-(NSNumber*) getNSNumberValueOn:(float)normalizedPosition;
-(float) getValueForNormalizedSize:(float)normalizedsize;
-(NSMutableArray*)getValuesFor:(NSArray*)normalizedVals;
-(float) getNormalizedPositionForValue:(float)value;
-(float) getNormalizedSizeForValue:(float)value;


+(BOOL) prepareSegments:(NSMutableArray*)segments forValues:(NSArray*)values;


@end

@interface SMrLinkedSlideViewData()
@property(nonatomic, strong) NSMutableArray * values;
@property(nonatomic, strong) NSMutableArray * valueSegments;

-(void) setLayerValue:(float)normalizedValue inSegment:(int) segmentIndex;
-(void) addAnimationForValues:(NSArray*) values keyTimes:(NSArray*)times onSegment:(int)segment;
-(void) addAnimationToStart:(BOOL)start OnSegment:(int)segment;

@end


@interface SMrSlideHandleView()

@property(nonatomic, strong) NSMutableArray * positions;
@property(nonatomic, strong) NSMutableArray * positionSegments;
@property(nonatomic, strong) NSMutableArray * linkedViews;

@property(nonatomic, strong) UIPanGestureRecognizer * panRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer * tapRecognizer;
@property(nonatomic) int activeSegment;
@property(nonatomic) BOOL activeSegmentOnStart;
@end

#pragma mark - SMrSlideHandleView implementation
@implementation SMrSlideHandleView

- (id)init{
    self = [super init];
    if(self){
        [self baseInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self baseInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseInit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id) initWithStartPos:(float)start andEndPos:(float)end lockedDirection:(eDirections) direction{
    self = [super init];
    if(self){
        [self baseInit];
        if(direction == DIR_HORIZONTAL || direction == DIR_VERTICAL){
            self.lockedDirection = direction;
        }
        
    }
    return self;
}

-(id) initWithStartPos:(float)start endPos:(float)end andLinkedViews:(NSArray*) slideViewDataArray{
    self = [super init];
    if(self){
        [self baseInit];
    }
    return self;
    
}

-(void) baseInit{
    self.lockedDirection = DIR_HORIZONTAL;
    self.positions = [NSMutableArray new];
    self.positionSegments = [NSMutableArray new];
    self.linkedViews = [NSMutableArray new];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:self.panRecognizer];
    [self addGestureRecognizer:self.tapRecognizer];
    self.activeSegment = 0;
    self.activeSegmentOnStart = YES;
    CGRect frm = self.frame;
    self.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.frame = frm;
}

-(void) addLinkedView:(SMrLinkedSlideViewData*)linkedView{
    [self.linkedViews addObject:linkedView];
}

-(void) addPosition:(float) position{
    NSNumber * num = [NSNumber numberWithFloat:position];
    if(self.positions.count == 0){
        [self.positions addObject:num];
    } else {
        //insert it on the right position
        NSNumber * existing;
        BOOL added = NO;
        for(int i = 0 ; i < self.positions.count; ++i ){
            existing = [self.positions objectAtIndex:i];
            if ([num floatValue] < [existing floatValue]) {
                [self.positions insertObject:num atIndex:i];
                added = YES;
                break;
            }
        }
        if(!added) [self.positions addObject:num];
    }
    [self prepareSegments];
}
-(void) reset{
    if(![self.positionSegments count]) return;
    _ValueSegment * vs = [self.positionSegments objectAtIndex:0];
    
    NSNumber * pos = [vs getNSNumberValueOn:0.0];
    
    [self.layer setValue:pos forKeyPath:[self keyPath]];
    
    for(SMrLinkedSlideViewData * linkedView in self.linkedViews){
        [linkedView setLayerValue:0.0 inSegment:0];
    }
    
    self.activeSegment = 0;
    self.activeSegmentOnStart = YES;
    
}

-(void) setStart:(float)start andEnd:(float)end{
    self.positions = [NSMutableArray new];
    [self addPosition:start];
    [self addPosition:end];
}

-(NSString *)keyPath{
    NSString * keyPath = @"position.x";
    if(self.lockedDirection == DIR_VERTICAL){
        keyPath = @"position.y";
    }
    return keyPath;
}

-(void) prepareSegments{
    if(self.positions.count < 2) return;
    [_ValueSegment prepareSegments:self.positionSegments forValues:self.positions];
}

#pragma mark - slide manipulation & animation

- (void)onPan:(UIPanGestureRecognizer *)sender{

    static CGPoint startPos;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        startPos = self.layer.position;
    }
    
    CGPoint pos = [sender translationInView:self];
    float val;
    int segment;
    if(self.lockedDirection == DIR_VERTICAL){
        pos.x = startPos.x;
        pos.y += startPos.y;
        val = pos.y;
    } else {
        pos.x += startPos.x;
        pos.y = startPos.y;
        val = pos.x;
    }

    
    segment = [self getSegmentForPosition:val];
    _ValueSegment * vs = [self.positionSegments objectAtIndex:segment];
    val = [vs getNormalizedPositionForValue:val];
    
    if(sender.state == UIGestureRecognizerStateEnded){
        //animate to valid state
        CGPoint speed2d = [sender velocityInView:self];
        float speed;
        if(self.lockedDirection == DIR_VERTICAL){
            speed = speed2d.y;
        } else {
            speed = speed2d.x;
        }
        speed = [vs getNormalizedSizeForValue:speed];
        [self animateFromPosition:val inSegment:segment withSpeed:speed];
        return;
    }
    
    if(segment == 0 && val < 0.00001) return;
    if(segment == self.positionSegments.count - 1 && val > 0.9999 ) return ;
    
    self.layer.position = pos;

    
    for(SMrLinkedSlideViewData * linkedData in self.linkedViews){
        [linkedData setLayerValue:val inSegment:segment];
    }
    
}


- (void)onTap:(UITapGestureRecognizer *)sender{
    if(self.activeSegmentOnStart){
        //go to the prev. segment start
        if(self.activeSegment == 0){
            //can't do that
            self.activeSegmentOnStart = NO;
        } else {
            self.activeSegment--;
        }
    } else {
        //go to the next segment end
        if(self.activeSegment == self.positionSegments.count - 1){
            //can't do that
            self.activeSegmentOnStart = YES;
        } else {
            self.activeSegment++;
        }
    }
    
    [self animateToSegment:self.activeSegment start:self.activeSegmentOnStart];
}

-(int) getSegmentForPosition:(float)pos{
    _ValueSegment * posSeg = [self.positionSegments objectAtIndex:0];
    if(pos < posSeg.start) return 0;
    
    int i = 0;
    for(i = 0; i < self.positionSegments.count; ++i){
        posSeg = [self.positionSegments objectAtIndex:i];
        if([posSeg isValInside:pos]) return i;
    }
    return i-1; //last one
}

-(void) animateFromPosition:(float)pos inSegment:(int)segment withSpeed:(float)speed{
    
    BOOL haveTwoSteps = NO;
    float dist0, dist1;
    float target0, target1 = -1.0;
    
    
    _ValueSegment * posSeg = [self.positionSegments objectAtIndex:segment];
    float gravity = [posSeg getNormalizedSizeForValue:GRAVITY];
    
    if(pos < 0.5 && speed < 0.0) {
        //animate to 0
        dist0 = pos;
        target0 = 0.0;
    } else if(pos > 0.5 && speed > 0.0){
        //animate to  1
        dist0 = 1.0 - pos;
        target0 = 1.0;
    } else {
        //find peek
        haveTwoSteps = YES;
        gravity *= 2.0;
        target0 = speed*speed / gravity;
        if(speed < 0.0) target0 *= -1.0;
        target0 += pos;
        if((pos < 0.5 && target0 > 0.5) || (pos > 0.5 && target0 < 0.5)){
            //crossing border
            target0 = (target0 + 2.0) * 0.2;
            if(target0 > 0.5) target1 = 1.0;
            else target1 = 0.0;
        } else {
            if(target0 < 0.5) target1 = 0.0;
            else target1 = 1.0;
        }
        
        if(target0 > 1.0) target0 = 1.0;
        if(target0 < 0.0) target0 = 0.0;
        
        dist0 = fabsf(target0 - pos);
        dist1 = fabsf(target1 - target0);
    }
    
    
    float time0 = sqrtf( [posSeg getValueForNormalizedSize:dist0] / gravity)  * 0.02;
    NSString * keyPath = @"position.x";
    if(self.lockedDirection == DIR_VERTICAL){
        keyPath = @"position.y";
    }
    
    float time1 = 0.0;
    
    NSMutableArray * positions = [NSMutableArray new];
    NSMutableArray * convertedPositions = [NSMutableArray new];
    NSMutableArray * timing = [NSMutableArray new];
    
    [positions addObject:[NSNumber numberWithFloat:pos]];
    [timing addObject:[NSNumber numberWithFloat:0.0f]];
    [positions addObject:[NSNumber numberWithFloat:target0]];
    
    float sumTime;
    if(haveTwoSteps){
        time1 = sqrtf( [posSeg getValueForNormalizedSize:dist1] / gravity) * 0.02;
        sumTime = time0 + time1;
        [timing addObject:[NSNumber numberWithFloat:time0/sumTime]];
        [positions addObject:[NSNumber numberWithFloat:target1]];
        [timing addObject:[NSNumber numberWithFloat:1.0]];
    }
    else {
        sumTime = time0;
        [timing addObject:[NSNumber numberWithFloat:1.0]];
    }
    convertedPositions = [posSeg getValuesFor:positions];

    [self.layer setValue:[convertedPositions lastObject] forKeyPath:keyPath];
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    anim.values = convertedPositions;
    anim.calculationMode = kCAAnimationCubic;
    anim.keyTimes = timing;
    
      
    if(sumTime > 0.15) sumTime = 0.15;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:sumTime];

    for(SMrLinkedSlideViewData * linkedView in self.linkedViews){
        [linkedView addAnimationForValues:positions keyTimes:timing onSegment:segment];
    }
    
    [self.layer addAnimation:anim forKey:@"position.y"];
    [CATransaction commit];
    
    self.activeSegment = segment;
    self.activeSegmentOnStart = [[positions lastObject] floatValue] < 0.5;
    
}

-(void) animateToSegment:(int) segment start:(BOOL)start{
    if(segment < 0) segment = 0;
    else if (segment >= self.positionSegments.count) segment = self.positionSegments.count -1;
    
    _ValueSegment * vs = [self.positionSegments objectAtIndex:segment];
    NSNumber * pos = [vs getNSNumberValueOn:start?0.0:1.0];
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:self.keyPath];
    anim.fromValue = [self.layer valueForKeyPath:self.keyPath];
    anim.toValue = pos;
    
    [self.layer setValue:pos forKeyPath:self.keyPath];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.15];
    
    [self.layer addAnimation:anim forKey:@"tap"];
    for(SMrLinkedSlideViewData * linkedView in self.linkedViews){
        [linkedView addAnimationToStart:start OnSegment:segment];
    }
    [CATransaction commit];
}

@end


#pragma mark - SMrLinkedSlideViewData implementation
@implementation SMrLinkedSlideViewData
-(id) initWithLayerFromView:(UIView*)view startValue:(float)start endValue:(float)end andKeyPath:(NSString*) keyPath{
    if(!keyPath || !view) return nil;
    self = [super init];
    if(self){
        CGRect frm = view.frame;
        self.linkedLayer = view.layer;
        self.linkedLayer.anchorPoint = CGPointMake(0.0, 0.0);
        view.frame = frm;
        self.keyPath = keyPath;
        [self setStartValue:start andEndValue:end];
    }
    return self;
}
- (NSMutableArray *)positions{
    if(!_values){
        _values = [NSMutableArray new];
    }
    return _values;
}
-(void) setStartValue:(float)start andEndValue:(float)end{
    self.values = [NSMutableArray new];
    [self.values addObject:[NSNumber numberWithFloat:start]];
    [self.values addObject:[NSNumber numberWithFloat:end]];
    [self prepareSegments];
}

-(void) insertValue:(float) val atIndex:(int)index{
    if(index >= self.values.count) index = self.values.count - 1;
    [self.values insertObject:[NSNumber numberWithFloat:val] atIndex:index];
    [self prepareSegments];
}

-(void) addPoint:(float) val{
    [self.values addObject:[NSNumber numberWithFloat:val]];
    [self prepareSegments];
}

-(void) prepareSegments{
    if(!_valueSegments) _valueSegments = [NSMutableArray new];
    [_ValueSegment prepareSegments:self.valueSegments forValues:self.values];
}

-(void) setLayerValue:(float)normalizedValue inSegment:(int) segmentIndex{
    if(segmentIndex < 0) segmentIndex = 0;
    else if(segmentIndex >= self.valueSegments.count) segmentIndex = self.valueSegments.count - 1;
    _ValueSegment * valSegment = [self.valueSegments objectAtIndex:segmentIndex];
    float val = [valSegment getValueOn:normalizedValue];
    [self.linkedLayer setValue:[NSNumber numberWithFloat:val] forKeyPath:self.keyPath];
}


-(void) addAnimationForValues:(NSArray*) values keyTimes:(NSArray*)times onSegment:(int)segment{
    if(segment < 0) segment = 0;
    else if(segment >= self.valueSegments.count) segment = self.valueSegments.count - 1;
    
    _ValueSegment * targetSegment = [self.valueSegments objectAtIndex:segment];

    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:self.keyPath];
    NSArray * convertedVals = [targetSegment getValuesFor:values];
    anim.values = convertedVals;
    anim.keyTimes = times;
    anim.calculationMode = kCAAnimationCubic;
    [self.linkedLayer addAnimation:anim forKey:@"move"];
    [self.linkedLayer setValue:[convertedVals lastObject] forKeyPath:self.keyPath];

}

-(void) addAnimationToStart:(BOOL)start OnSegment:(int)segment{
    if(segment < 0) segment = 0;
    else if(segment >= self.valueSegments.count) segment = self.valueSegments.count - 1;
    
    _ValueSegment *vs = [self.valueSegments objectAtIndex:segment];
    
    NSNumber * targetVal = [vs getNSNumberValueOn:start?0.0:1.0];
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:self.keyPath];
    anim.fromValue = [self.linkedLayer valueForKeyPath:self.keyPath];
    anim.toValue = targetVal;
    [self.linkedLayer addAnimation:anim forKey:@"jump"];
    [self.linkedLayer setValue:targetVal forKeyPath:self.keyPath];
}

@end

#pragma mark - _positionSegment implementation
@implementation _ValueSegment

-(id) initWithStart:(float)start andEnd:(float)end{
    self = [super init];
    if(self){
        [self setStart:start andEnd:end];
    }
    return self;
}

-(void) setStart:(float)start andEnd:(float)end{
    //normalize values
    
    _start = start;
    end -= start;
    if(end > 0.0000001 || end < -0.0000001){
        _coeff = end;
    } else {
        _coeff = end < 0.0 ? 1.0 : -1.0;
    }
}

-(BOOL) isValInside:(float)val{
   return _coeff > 0 ? (val >= _start && val <= _coeff) : (val >= _start && val <= _coeff);
}

-(float) getValueOn:(float)normalizedPosition{
    return _start + _coeff*normalizedPosition;
}
-(float) getValueForNormalizedSize:(float)normalizedsize{
    return _coeff*normalizedsize;
}
-(NSMutableArray*)getValuesFor:(NSArray*)normalizedVals{
    NSMutableArray * ret = [NSMutableArray new];
    float val;
    for(NSNumber * num in normalizedVals){
        val = [num floatValue];
        [ret addObject:[self getNSNumberValueOn:val]];
    }
    
    return ret;
}

-(NSNumber*) getNSNumberValueOn:(float)normalizedPosition{
    return [NSNumber numberWithFloat:(_start + _coeff*normalizedPosition)];
}

-(float) getNormalizedPositionForValue:(float)value{
    float ret = (value - _start) / _coeff;
//    if(ret < 0.0) return 0.0;
//    else if(ret > 1.0) return 1.0;
    
    return ret;
}

-(float) getNormalizedSizeForValue:(float)value{
    return value / _coeff;
}

- (float)start{
    return _start;
}

- (float)coeff{
    return _coeff;
}

+(BOOL) prepareSegments:(NSMutableArray*)segments forValues:(NSArray*)values{
    if(!segments || !values) return NO;
    [segments removeAllObjects];
    int currentIndex = 0;
    float startVal = [[values objectAtIndex:currentIndex] floatValue];
    float endValue;
    _ValueSegment * segment;
    for(currentIndex = 1; currentIndex < values.count ; ++currentIndex){
        endValue = [[values objectAtIndex:currentIndex] floatValue];
        segment = [[_ValueSegment alloc] initWithStart:startVal andEnd:endValue];
        [segments addObject:segment];
        startVal = endValue;
    }
    return YES;
}

@end
