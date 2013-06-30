//
//  SMCyEmbedSBSegue.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyEmbedSBSegue.h"

@implementation SMCyEmbedSBSegue

- (void)perform{
    UIViewController * host = self.sourceViewController;
    UIViewController * embedingVC = self.destinationViewController;
    NSString * hostViewName = embedingVC.title;
    UIView * hostView = nil;
    if([host respondsToSelector:NSSelectorFromString(hostViewName)]){
        id hostObj = [host valueForKey:hostViewName];
        if([hostObj isKindOfClass:[UIView class]]){
            hostView = (UIView*)hostObj;
        }
    } else {
        return;
    }
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:self.identifier bundle:nil];
    UIViewController * realDestination = [sb instantiateInitialViewController];
    
    if(realDestination && hostView){
        [realDestination willMoveToParentViewController:host];
        //maybe we should clear all subviews from hostView
        [host addChildViewController:realDestination];
        realDestination.view.frame = hostView.bounds;
        [hostView addSubview:realDestination.view];
        [realDestination didMoveToParentViewController:host];
        
    }
    
}

@end
