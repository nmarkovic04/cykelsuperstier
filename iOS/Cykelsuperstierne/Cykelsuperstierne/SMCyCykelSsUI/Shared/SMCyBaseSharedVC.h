//
//  SMCyBaseSharedVC.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"

@interface SMCyBaseSharedVC : SMCyBaseVC{

}

@property(nonatomic) BOOL isPushedToNavController;
@property(nonatomic) BOOL isModallyPresented;

-(void) prepareViewForPush;
-(void) prepareViewForModalPresent;
//NOTE: completion won't be called in case of push to navigation controller
-(BOOL) backCloseAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;

+(SMCyBaseSharedVC*)createInstanceFromNib;
+(SMCyBaseSharedVC*) showModalOnViewController:(UIViewController*)parentVC animated:(BOOL)animated withCompletion:(void (^)(void))completion;
+(SMCyBaseSharedVC*) pushOnNavigationController:(UINavigationController*)navController animated:(BOOL)animated;

@end
