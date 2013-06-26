//
//  SMrDoubleSidedImage+Protected.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrDoubleSidedImage+Protected.h"
#import "SMrUtil.h"

@implementation SMrDoubleSidedImage (Protected)

-(void) baseInit{
    self.shouldAutoPrepareBackImageOnSwap = NO;
    self.shouldResetBackImageOnSwap = NO;
}

-(void)notifyFrontImageReady{
    [self notifyDelegateWithSelector:@selector(frontImageIsReady:)];
}
-(void)notifyFrontImageReseted{
    [self notifyDelegateWithSelector:@selector(frontImageReseted:)];
}
-(void)notifyFrontImageChanged{
    [self notifyDelegateWithSelector:@selector(frontImageChanged:)];
}
-(void)notifyBackImageReady{
    [self notifyDelegateWithSelector:@selector(backImageIsReady:)];
}
-(void)notifyBackImageReseted{
    [self notifyDelegateWithSelector:@selector(backImageReseted:)];
}
-(void)notifyBackImageChanged{
    [self notifyDelegateWithSelector:@selector(backImageChanged:)];
}
-(void)notifyImagesSwapped{
    [self notifyDelegateWithSelector:@selector(imagesSwapped:)];
}
-(void)notifyBackPrepareFailed{
    [self notifyDelegateWithSelector:@selector(frontImageIsReady:)];
}
-(void)notifyBackPrepareCanceled{
    [self notifyDelegateWithSelector:@selector(frontImageIsReady:)];
}
-(void)notifyTryingToSetLockedFront{
    [self notifyDelegateWithSelector:@selector(tryingToSetLockedFront:)];
}
-(void)notifyTryingToSetLockedBack{
    [self notifyDelegateWithSelector:@selector(tryingToSetLockedBack:)];
}


-(void)notifyDelegateWithSelector:(SEL) sel{
    
    [SMrUtil notifyOnMainThreadDelegate:self.delegate WithSelector:sel AndObject:self];
    
//    
//    if(self.delegate && [self.delegate respondsToSelector:sel]){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [self.delegate performSelector:sel withObject:self];
//#pragma clang diagnostic pop
//        }];
//    }
    
}

@end
