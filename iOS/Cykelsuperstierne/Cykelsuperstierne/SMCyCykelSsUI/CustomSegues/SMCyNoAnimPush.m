//
//  SMCyNoAnimPush.m
//  Cykelsuperstierne
//
//  Created by Rasko on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyNoAnimPush.h"

@implementation SMCyNoAnimPush

-(void)perform{
    UIViewController * host = self.sourceViewController;
    UIViewController * dest = self.destinationViewController;
    if(host && host.navigationController && dest){
        [host.navigationController pushViewController:dest animated:NO];
    }
}

@end
