//
//  SMrDoubleSidedImage.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMrDoubleSidedImage;

@protocol SMrDoubleSidedImageDelegate <NSObject>
@optional
-(void) frontImageIsReady:(SMrDoubleSidedImage*) dsImage; //from nil to <something>
-(void) frontImageReseted:(SMrDoubleSidedImage*) dsImage; //from <something> to nil
-(void) frontImageChanged:(SMrDoubleSidedImage*) dsImage; //from <something> to <something_else>
-(void) backImageIsReady:(SMrDoubleSidedImage*) dsImage;
-(void) backImageReseted:(SMrDoubleSidedImage*) dsImage;
-(void) backImageChanged:(SMrDoubleSidedImage*) dsImage;
-(void) imagesSwapped:(SMrDoubleSidedImage*) dsImage;
-(void) backImagePrepareFailed:(SMrDoubleSidedImage*) dsImage;
-(void) backImagePrepareCanceled:(SMrDoubleSidedImage*) dsImage;
-(void) tryingToSetLockedFront:(SMrDoubleSidedImage*) dsImage;
-(void) tryingToSetLockedBack:(SMrDoubleSidedImage*) dsImage;
@end

@interface SMrDoubleSidedImage : NSObject{
    @protected
    __strong UIImage * _frontImage;
    __strong UIImage * _backImage;
}

@property(nonatomic, assign) BOOL shouldAutoPrepareBackImageOnSwap; //if YES, shouldResetBackImageOnSwap will be ignored and backImage will be reseted (set to nil)
@property(nonatomic, assign) BOOL shouldResetBackImageOnSwap;

@property(nonatomic, weak) id<SMrDoubleSidedImageDelegate> delegate;
@property(nonatomic, strong) UIImage * frontImage;
@property(nonatomic, strong) UIImage * backImage;

-(id) initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate;
-(id) initWithFrontImage:(UIImage*)image;
-(id) initWithBackImage:(UIImage*)image;
-(id) initWithFrontImage:(UIImage*)frontImage andBackImage:(UIImage*)backImage;
-(id) initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate FrontImage:(UIImage*)frontImage andBackImage:(UIImage*)backImage;

-(BOOL) prepareBackImage;
-(BOOL) cancelPrepareBackImage;
-(void) swap;
-(BOOL) canSetFrontImage;
-(BOOL) canSetBackImage;

@end
