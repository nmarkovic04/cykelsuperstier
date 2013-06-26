//
//  SMrDSImageView.m
//  testAPIRequests
//
//  Created by Rasko on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrDSImageView.h"
#import "SMrDoubleSidedImage.h"
#import <QuartzCore/QuartzCore.h>
#import "SMrUtil.h"
#import "SMrRequest.h"
#import "SMrURLImage.h"

typedef void(^AnimCompletion)(void);

@interface SMrDSImageView()
@property(nonatomic, strong) CALayer * frontLayer;
@property(nonatomic, strong) CALayer * backLayer;
@property(nonatomic, strong) CABasicAnimation * frontAnim;
@property(nonatomic, strong) CABasicAnimation * backAnim;
@property(nonatomic, strong) AnimCompletion animCompletionBlock;
@property(nonatomic, assign) BOOL tempAutoSwap;
@end

@implementation SMrDSImageView



- (id)init{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self baseInit];
    }
    
    return self;
    
}

-(id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

-(void) baseInit{
    self.dsImage = [SMrDoubleSidedImage new];
    self.dsImage.delegate = self;
    if([super image]){
        [self setFrontImage:[super image]];
        [super setImage:nil];
    }
    if([super highlightedImage]) {
        [self setBackImage:[super highlightedImage]];
        [super setHighlightedImage:nil];
    }
    
    [super setImage:nil];
    [super setHighlightedImage:nil];
    
    if(!_frontLayer || !_backLayer){
        _frontLayer = [CALayer new];
        _backLayer = [CALayer new];
        _frontLayer.frame = self.layer.bounds;
        _backLayer.frame = self.layer.bounds;
        _frontLayer.opacity = 1.0;
        _backLayer.opacity = 1.0;
        [self.layer addSublayer:_backLayer];
        [self.layer addSublayer:_frontLayer];
    }
    self.layer.masksToBounds = YES;
    _swapDuration = 0.5;
    [self setBorderColor:[UIColor whiteColor]];
    _autoSwap = NO;
}


#pragma mark - setters/getters

- (void)setImage:(UIImage *)image{
//    [super setImage:image];
    [self setFrontImage:image];
}

- (UIImage *)image{
    return [self frontImage];
}

-(void)setHighlightedImage:(UIImage *)highlightedImage{
//    [super setHighlightedImage:highlightedImage];
    [self setBackImage:highlightedImage];
}

-(UIImage *)highlightedImage{
    return [self backImage];
}

-(void)setFrontImage:(UIImage *)frontImage{
    [_dsImage setFrontImage:frontImage];
}

-(UIImage *)frontImage{
    return [_dsImage frontImage];
}

-(void)setBackImage:(UIImage *)backImage{
    [_dsImage setBackImage:backImage];
}

-(UIImage *)backImage{
    return [_dsImage backImage];
}

-(BOOL)highlighted{
    return _highlighted;
}

-(void) setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
}

-(void)setRoundCorner:(float)roundCorner{
    self.layer.cornerRadius = roundCorner;
}

-(float)roundCorner{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(float)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(float)borderWidth{
    return self.layer.borderWidth;
}

- (void)setDsImage:(SMrDoubleSidedImage *)dsImage{
    _dsImage = dsImage;
    _dsImage.delegate = self;
    [self frontImageChanged:_dsImage];
    [self backImageChanged:_dsImage];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark - SMrDoubleSidedImageDelegate methods

-(void) frontImageIsReady:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self frontImageChanged:dsImage];
    [self notifyFrontReady];
}

-(void) frontImageReseted:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self frontImageChanged:dsImage];
    [self notifyFrontChanged];
}

-(void) frontImageChanged:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self setAndResizeFront];
    [self notifyFrontChanged];
}

-(void) backImageIsReady:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self backImageChanged:dsImage];
    [self notifyBackReady];
    if(self.tempAutoSwap || self.autoSwap){
        [self swap];
    }
}

-(void) backImageReseted:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self backImageChanged:dsImage];
    [self notifyBackChanged];
}

-(void) backImageChanged:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self setAndResizeBack];
    [self notifyBackChanged];
}
-(void) imagesSwapped:(SMrDoubleSidedImage*) dsImage{
    if(dsImage != self.dsImage)return;
    [self notifyImagesSwapped];
}

-(void) backImagePrepareFailed:(SMrDoubleSidedImage*) dsImage{
    [self notifyPrepareFailed];
}

-(void) backImagePrepareCanceled:(SMrDoubleSidedImage*) dsImage{
    [self notifyPrepareCanceled];
}

-(void) tryingToSetLockedFront:(SMrDoubleSidedImage*) dsImage{
    
}

-(void) tryingToSetLockedBack:(SMrDoubleSidedImage*) dsImage{
    
}

#pragma mark - resize
-(void)setAndResizeFront{
    [self.frontLayer setContents:(id)[self.dsImage.frontImage CGImage]];
    [self setLayer:self.frontLayer WithImage:self.dsImage.frontImage ToFILLParentSize:self.layer.bounds.size];
}

-(void)setAndResizeBack{
    [self.backLayer setContents:(id)[self.dsImage.backImage CGImage]];
    [self setLayer:self.backLayer WithImage:self.dsImage.backImage ToFILLParentSize:self.layer.bounds.size];
}

-(void) setLayer:(CALayer*)layer WithImage:(UIImage*)image ToFILLParentSize:(CGSize)parentSize{
    if(!layer || !image) return;
    
    [layer setContents:(id)[image CGImage]];
    CGRect frm; frm.size = image.size;
    float scaleCoef = [self getCoeficientForChildSize:frm.size ToFill:YES parentSize:parentSize];
    frm.size.width *= scaleCoef;
    frm.size.height *= scaleCoef;
    frm.origin.x = (parentSize.width - frm.size.width) *0.5;
    frm.origin.y = (parentSize.height - frm.size.height) *0.5;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    [CATransaction setDisableActions:YES];
    layer.frame = frm;
    [CATransaction commit];
}

-(float) getCoeficientForChildSize:(CGSize)childSize ToFill:(BOOL)shouldFill parentSize:(CGSize)parentSize{
    float hCoeff = parentSize.height / childSize.height;
    float wCoeff = parentSize.width / childSize.width;
    if(shouldFill){
        return MAX(hCoeff, wCoeff);
    } else {
        return MIN(hCoeff, wCoeff);
    }
}


#pragma mark - swap animations and back preparation

-(void) prepareBackImageWithAutoswap:(BOOL)autoswap{
    self.tempAutoSwap = autoswap;
    [self.dsImage prepareBackImage];
}

-(void) cancelBackPrepare{
    [self.dsImage cancelPrepareBackImage];
}

-(void) swap{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:self.swapDuration];
    [self prepareAnimationFade];
    [CATransaction setCompletionBlock: self.animCompletionBlock];
    [self.frontLayer addAnimation:self.frontAnim forKey:@"frontAnim"];
    [self.backLayer addAnimation:self.backAnim forKey:@"backAnim"];
    [CATransaction commit];
}

-(void) prepareAnimationFade{
    self.frontAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.frontAnim.fromValue = [NSNumber numberWithFloat:1.0f];
    self.frontAnim.toValue = [NSNumber numberWithFloat:0.0f];
    self.frontAnim.fillMode = kCAFillModeBoth;
    self.frontAnim.removedOnCompletion = NO;
    self.backAnim = nil;
    
    __weak SMrDSImageView * localSelfCopy = self;
    self.animCompletionBlock = ^(){
        [localSelfCopy.dsImage swap];
        //swap layers
        [localSelfCopy.backLayer removeFromSuperlayer];
        [localSelfCopy.layer addSublayer:localSelfCopy.backLayer];
        CALayer * tempL = localSelfCopy.frontLayer;
        localSelfCopy.frontLayer = localSelfCopy.backLayer;
        localSelfCopy.backLayer = tempL;
        localSelfCopy.backLayer.opacity = 1.0;
        [localSelfCopy.backLayer removeAllAnimations];
    };
}

#pragma mark - notification

-(void) notifyFrontReady{
    [self notifyDelegateWithSelector:@selector(frontImageIsReady:)];
}
-(void) notifyFrontChanged{
    [self notifyDelegateWithSelector:@selector(frontImageChanged:)];
}
-(void) notifyBackReady{
     [self notifyDelegateWithSelector:@selector(backImageIsReady:)];
}
-(void) notifyBackChanged{
     [self notifyDelegateWithSelector:@selector(backImageChanged:)];
}
-(void) notifyPrepareFailed{
     [self notifyDelegateWithSelector:@selector(backImagePrepareFailed:)];
}
-(void) notifyPrepareCanceled{
     [self notifyDelegateWithSelector:@selector(backImagePrepareCanceled:)];
}
-(void) notifyImagesSwapped{
     [self notifyDelegateWithSelector:@selector(imagesSwapped:)];
}

-(void) notifyDelegateWithSelector:(SEL)sel{
    
    [SMrUtil notifyDelegate:self.delegate WithSelector:sel AndObject:self];
}


#pragma mark -
- (void)dealloc{
    self.dsImage = nil;
}

@end
