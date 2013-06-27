//
//  SMCyBusyController.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"

@interface SMCyBusyController : SMCyBaseVC
+(SMCyBusyController*)showOnViewController:(UIViewController*)vc;
+(void)close;
+(BOOL) isVisible;
@end
