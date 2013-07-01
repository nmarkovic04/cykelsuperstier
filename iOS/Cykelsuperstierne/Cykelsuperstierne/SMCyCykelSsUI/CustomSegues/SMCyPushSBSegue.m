//
//  SMCyPushSBSegue.m
//  Cykelsuperstierne
//
//  Created by Rasko on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyPushSBSegue.h"

@implementation SMCyPushSBSegue


- (void)perform{
    UIViewController * host = self.sourceViewController;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:self.identifier bundle:nil];
    UIViewController * realDestination = [sb instantiateInitialViewController];
    
    if(realDestination && host.navigationController){
        [host.navigationController pushViewController:realDestination animated:YES];
    }
    
}

@end
