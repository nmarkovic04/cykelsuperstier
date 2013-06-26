//
//  SMrDoubleSidedImage+Protected.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrDoubleSidedImage.h"

@interface SMrDoubleSidedImage (Protected)
-(void)baseInit;
-(void)notifyFrontImageReady;
-(void)notifyFrontImageReseted;
-(void)notifyFrontImageChanged;
-(void)notifyBackImageReady;
-(void)notifyBackImageReseted;
-(void)notifyBackImageChanged;
-(void)notifyImagesSwapped;
-(void)notifyBackPrepareFailed;
-(void)notifyBackPrepareCanceled;
-(void)notifyTryingToSetLockedFront;
-(void)notifyTryingToSetLockedBack;
-(void)notifyDelegateWithSelector:(SEL)sel;
@end
