//
//  SMCyBusyController.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBusyController.h"

@interface SMCyBusyController ()

@end

@implementation SMCyBusyController

static SMCyBusyController * activeBC = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(SMCyBusyController*)showOnViewController:(UIViewController*)vc{
    [SMCyBusyController createActiveBusyController];
    if(activeBC){
        if([activeBC parentViewController]){
            [activeBC.view removeFromSuperview];
            [activeBC removeFromParentViewController];
        }
        
        [activeBC willMoveToParentViewController:vc];
        [vc addChildViewController:activeBC];
        activeBC.view.frame = vc.view.bounds;
        [vc.view addSubview:activeBC.view];
        [activeBC didMoveToParentViewController:vc];
    }
    return activeBC;
}

+(void)close{
    if(!activeBC) return;
    if([activeBC parentViewController]){
        [activeBC.view removeFromSuperview];
        [activeBC removeFromParentViewController];
    }
    activeBC = nil;
    
//    [activeBC dismissViewControllerAnimated:YES completion:^{
//        activeBC = nil;
//    }];
}

+(BOOL) isVisible{
    if(activeBC && [activeBC presentingViewController]) return YES;
    return NO;
}


+(SMCyBusyController*)createActiveBusyController{
        if(!activeBC){
            activeBC = [[SMCyBusyController alloc] initWithNibName:@"SMCyBusyController" bundle:nil];
        }
        return activeBC;
}

@end
