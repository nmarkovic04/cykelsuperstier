//
//  SMrDoubleSidedImage.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrDoubleSidedImage+Protected.h"

@implementation SMrDoubleSidedImage
-(id)init{
    self = [super init];
    if(self){
        [self baseInit];
    }
    return self;
}

-(id) initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate{
    self = [super init];
    if(self){
        [self baseInit];
        _delegate = delegate;
    }
    return self;
}

-(id) initWithFrontImage:(UIImage*)image{
    self = [super init];
    if(self){
        [self baseInit];
        _frontImage = image;
    }
    return self;
}

-(id) initWithBackImage:(UIImage*)image{
    self = [super init];
    if(self){
        [self baseInit];
        _backImage = image;
    }
    return self;
}

-(id) initWithFrontImage:(UIImage*)frontImage andBackImage:(UIImage*)backImage{
    self = [super init];
    if(self){
        [self baseInit];
        _frontImage = frontImage;
        _backImage = backImage;
    }
    return self;
}

-(id) initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate FrontImage:(UIImage*)frontImage andBackImage:(UIImage*)backImage{
    self = [super init];
    if(self){
        [self baseInit];
        _delegate = delegate;
        _frontImage = frontImage;
        _backImage = backImage;
    }
    return self;
}



- (void)setFrontImage:(UIImage *)frontImage{
    if(![self canSetFrontImage]){
        [self notifyTryingToSetLockedFront];
        return;
    }
    if(frontImage == _frontImage) return;
    BOOL prevStateNIL = (_frontImage == nil);
    _frontImage = frontImage;
    
    if(frontImage && prevStateNIL){
        [self notifyFrontImageReady];
    } else if(!frontImage && !prevStateNIL){
        [self notifyFrontImageReseted];
    }else{
        [self notifyFrontImageChanged];
    }
    
}

- (void)setBackImage:(UIImage *)backImage{
    if(![self canSetBackImage]){
        [self notifyTryingToSetLockedBack];
        return;
    }
    if(backImage == _backImage) return;
    BOOL prevStateNIL = (_backImage == nil);
    _backImage = backImage;
    
    if(backImage && prevStateNIL){
        [self notifyBackImageReady];
    } else if(!backImage && !prevStateNIL){
        [self notifyBackImageReseted];
    } else {
        [self notifyBackImageChanged];
    }

}

-(BOOL) prepareBackImage{
    return NO;
}

-(BOOL) cancelPrepareBackImage{
    return NO;
}

-(void) swap{
    UIImage * oldFront = self.frontImage;
    self.frontImage = self.backImage;
    
    if(self.shouldAutoPrepareBackImageOnSwap){
        self.backImage = nil;
        [self prepareBackImage];
    } else if(self.shouldResetBackImageOnSwap) {
        self.backImage = nil;
    } else {
        self.backImage = oldFront;
    }
    
    [self notifyImagesSwapped];
}

-(BOOL) canSetFrontImage{
    return YES;
}
-(BOOL) canSetBackImage{
    return YES;
}

- (void)dealloc{
}

@end
