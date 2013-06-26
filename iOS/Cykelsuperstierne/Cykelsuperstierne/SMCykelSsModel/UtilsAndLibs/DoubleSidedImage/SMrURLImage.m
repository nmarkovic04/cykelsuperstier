//
//  SMrURLImage.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrURLImage.h"
#import "SMrDoubleSidedImage+Protected.h"
#import "SMrRequest.h"

@interface SMrURLImage()
@property(nonatomic, assign) BOOL unlockUrlImageForWriting;
@end

@implementation SMrURLImage

UIImage * sDefaultImage = nil;

-(id)initWithImageURL:(NSString*)imageUrl{
    self = [super initWithFrontImage:sDefaultImage];
    if(self){
        _imageUrl = imageUrl;
    }
    return self;
}

-(id)initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate ImageURL:(NSString*)imageUrl{
    self = [super initWithDelegate:delegate FrontImage:sDefaultImage andBackImage:nil];
    if(self){
        _imageUrl = imageUrl;
    }
    return self;
    
}

-(id)initWithImageURL:(NSString*)imageUrl andDefaultImage:(UIImage*)image{
    self = [super initWithFrontImage:image];
    if(self){
        if(image){
            self.defaultImage = image;
        }
    }
    return self;
    
}

-(id)initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate ImageURL:(NSString*)imageUrl andDefaultImage:(UIImage*)image{
    self = [super initWithDelegate:delegate FrontImage:image andBackImage:nil];
    if(self){
        _imageUrl = imageUrl;
        if(image){
            self.defaultImage = image;
        }

    }
    return self;
    
}

-(void)baseInit{
    [super baseInit];
    _backImage = nil;
    self.shouldResetBackImageOnSwap = YES;
    self.defaultImage = sDefaultImage;
}

- (void)setDefaultImage:(UIImage *)defaultImage{
    if(defaultImage && (!self.frontImage || self.frontImage == _defaultImage)){
        self.frontImage = defaultImage;
    }
    _defaultImage = defaultImage;
}

-(void)swap{
    //NOTE: [super swap] will notify delegate that swap is finished
    self.unlockUrlImageForWriting = YES;
    _isUrlImageInFront = !_isUrlImageInFront;
    [super swap]; 
    self.unlockUrlImageForWriting = NO;
}

-(BOOL)prepareBackImage{
    if(!self.imageUrl || self.imageUrl.length < 4) return NO;
    
    SMrRequest * request = [[SMrRequest alloc] initWithMainUrl:self.imageUrl];
    self.testRequest = request;
    __weak SMrURLImage * localSelfCopy = self;
    [request requestWithCompletion:^(SMrRequest* req){
        if(req.requestError.errorType != ET_FAILED && req.receivedData){
            UIImage *receivedImg = [UIImage imageWithData:req.receivedData];
            if(receivedImg){
                localSelfCopy.unlockUrlImageForWriting = YES;
                localSelfCopy.backImage = receivedImg;
                localSelfCopy.unlockUrlImageForWriting = NO;
            }
        }
    }];
    return YES;
}

- (BOOL)canSetFrontImage{
    return !self.isUrlImageInFront || self.unlockUrlImageForWriting;
}

-(BOOL)canSetBackImage{
    return self.isUrlImageInFront || self.unlockUrlImageForWriting;    
}

- (UIImage *)urlImage{
    return self.isUrlImageInFront?self.frontImage:self.backImage;
}

-(BOOL) isUrlImageReady{
    return self.urlImage != nil;
}

+(UIImage *)defaultImage{
    return sDefaultImage;
}

+(void)setDefaultImage:(UIImage *)image{
    sDefaultImage = image;
}

-(void) dealloc{
}

@end
