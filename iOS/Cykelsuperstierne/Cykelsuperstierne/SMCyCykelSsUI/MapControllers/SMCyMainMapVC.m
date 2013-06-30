//
//  SMCyMainMapVC.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMainMapVC.h"
#import "SMCyMainMapVC+Animations.h"
#import <QuartzCore/QuartzCore.h>
#import "SMrUtil.h"
#import "SMCyMenuController.h"

@interface SMCyMainMapVC ()

@end

@implementation SMCyMainMapVC

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
    [self performSegueWithIdentifier:@"SMCyMenu" sender:self];
    [self initializeOpenCloseStates];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    UIViewController * addedVC = childController;
    if([addedVC isKindOfClass:[UINavigationController class]]){
        addedVC = [addedVC.childViewControllers objectAtIndex:0];
    }
    if([addedVC isKindOfClass:[SMCyMenuController class]]){
        _menuVC = (SMCyMenuController*)addedVC;
    }
}

@end
