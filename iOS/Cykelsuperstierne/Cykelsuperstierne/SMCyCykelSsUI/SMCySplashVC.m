//
//  SMCySplash.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySplashVC.h"
#import "SMCyUser.h"

#define SPLASH_PAUSE 0.5f

@interface SMCySplashVC ()
@property BOOL isLoggedIn;
@end

@implementation SMCySplashVC

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
    [self performSelector:@selector(pushNextVC) withObject:nil afterDelay:SPLASH_PAUSE];
    self.isLoggedIn = [SMCyUser activeUser].isLoggedin;
	// Do any additional setup after loading the view.
}

-(void) pushNextVC{
//loginFromSplash    
//mapFromSplash
    if(self.isLoggedIn){
        [self performSegueWithIdentifier:@"mapFromSplash" sender:self];
    } else {
        [self performSegueWithIdentifier:@"loginFromSplash" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
