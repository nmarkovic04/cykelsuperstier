//
//  SMrDSImageView.h
//  testAPIRequests
//
//  Created by Rasko on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMrDoubleSidedImage.h"

@class SMrDSImageView;

@protocol SMrDSImageViewDelegate <NSObject>
-(void) frontImageIsReady:(SMrDSImageView*) dsImageView;
-(void) frontImageChanged:(SMrDSImageView*) dsImageView;
-(void) backImageIsReady:(SMrDSImageView*) dsImageView;
-(void) backImageChanged:(SMrDSImageView*) dsImageView;
-(void) backImagePrepareFailed:(SMrDSImageView*) dsImageView;
-(void) backImagePrepareCanceled:(SMrDSImageView*) dsImageView;
-(void) imagesSwapped:(SMrDSImageView*) dsImageView;
-(void) imageTapped:(SMrDSImageView*) dsImageView;
@end


@interface SMrDSImageView : UIImageView<SMrDoubleSidedImageDelegate>{
    BOOL _highlighted; //not really used
}


@property(nonatomic, strong) SMrDoubleSidedImage * dsImage;
@property(nonatomic, retain) UIImage * frontImage;
@property(nonatomic, retain) UIImage * backImage;


@property(nonatomic, assign) float swapDuration;
@property(nonatomic, assign) float roundCorner;
@property(nonatomic, strong) UIColor * borderColor;
@property(nonatomic, assign) float borderWidth;
@property(nonatomic, assign) BOOL autoSwap;

@property(nonatomic, weak) id<SMrDSImageViewDelegate> delegate;

-(void) prepareBackImageWithAutoswap:(BOOL)autoswap;
-(void) cancelBackPrepare;
-(void) swap;

@end
