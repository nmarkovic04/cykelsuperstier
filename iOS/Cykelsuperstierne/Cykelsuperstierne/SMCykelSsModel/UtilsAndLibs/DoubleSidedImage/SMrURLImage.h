//
//  SMrURLImage.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrDoubleSidedImage.h"
#import "SMrRequest.h"

@interface SMrURLImage : SMrDoubleSidedImage

@property(nonatomic, weak) SMrRequest * testRequest;

@property(nonatomic, strong) NSString * imageUrl;
@property(nonatomic, strong) UIImage * defaultImage;
@property(nonatomic, strong, readonly) UIImage * urlImage;
@property(nonatomic, assign, readonly) BOOL isUrlImageReady;
@property(nonatomic, assign, readonly) BOOL isUrlImageInFront;

-(id)initWithImageURL:(NSString*)imageUrl;
-(id)initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate ImageURL:(NSString*)imageUrl;
-(id)initWithImageURL:(NSString*)imageUrl andDefaultImage:(UIImage*)image;
-(id)initWithDelegate:(id<SMrDoubleSidedImageDelegate>)delegate ImageURL:(NSString*)imageUrl andDefaultImage:(UIImage*)image;


+(void)setDefaultImage:(UIImage*)image;
+(UIImage*)defaultImage;

@end
