//
//  SMCyLwFavorites.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyLwFavorites.h"
#import "SMCySettings.h"

@interface SMCyLwFavorites ()

@end

@implementation SMCyLwFavorites

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

- (IBAction)onSaveFavorites:(UIButton *)sender {
    //TODO: save favorites
    
    [self goToNextView];
    
}

- (IBAction)onSkip:(UIButton *)sender {
    [self goToNextView];
}

-(void) goToNextView{
    if([[SMCySettings sharedInstance] shouldShowFirstTimeIntro]){
        [self performSegueWithIdentifier:@"favoritesToFirstTimeIntro" sender:self];        
    } else {
        [self performSegueWithIdentifier:@"favoritesToMap" sender:self];
    }
}
@end
