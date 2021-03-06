//
//  SMCyMenuController.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMenuController.h"

@interface SMCyMenuController ()

@end

@implementation SMCyMenuController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<SMCyMenuDelegate>)delegate{
    return [SMCyMenu sharedInstance].delegate;
}

- (void)setDelegate:(id<SMCyMenuDelegate>)delegate{
    [SMCyMenu sharedInstance].delegate = delegate;
}

-(void) switchToUserMenu{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"userMenu" sender:self];
}

-(void) switchToMapMenu{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"mapMenu" sender:self];
}



@end
