//
//  SMPickAccountVC.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyLwPickAccountVC.h"
#import "SMrTranslator.h"
#import "SMCyBusyController.h"
#import "SMCyEmailSignupVC.h"

@interface SMCyLwPickAccountVC ()

- (IBAction)onFbLogin:(id)sender;
- (IBAction)onRegisterViaEmail:(UIButton *)sender;
- (IBAction)onSkip:(UIButton *)sender;
@end

@implementation SMCyLwPickAccountVC

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
    [[SMCyUser activeUser] addDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFbLogin:(id)sender {
     
    if([SMCyUser activeUser].accountType != AT_FACEBOOK){
        //this will create new fb account and try to log in
        [SMCyUser activeUser].accountType = AT_FACEBOOK;
    } else if([[SMCyUser activeUser] isLoggedin]){
        [self userDidLogIN:[SMCyUser activeUser]];
    } else {
        [[SMCyUser activeUser] login];
    }
}

- (IBAction)onRegisterViaEmail:(UIButton *)sender {
    
    if([SMCyUser activeUser].accountType != AT_EMAIL){
        //this will create new fb account and try to log in
        [SMCyUser activeUser].accountType = AT_EMAIL;
    } else if([[SMCyUser activeUser] isLoggedin]){
        [self userDidLogIN:[SMCyUser activeUser]];
        
        return;
    }
    
    [SMCyEmailSignupVC showModalOnViewController:self animated:YES withCompletion:^(){
        //do something
    }];

}

- (IBAction)onSkip:(UIButton *)sender {
}

#pragma mark - user delegate methods

-(void) userWillTryLogIN:(SMCyUser*)account{
    [SMCyBusyController showOnViewController:self];
}

-(void) userDidLogIN:(SMCyUser*)account{
//    if([SMCyBusyController isVisible]){
//        [SMCyBusyController close];
//    }
}

-(void) userFailedToLogIN:(SMCyUser*)account{
    if([SMCyBusyController isVisible]){
        [SMCyBusyController close];
    }

}

-(void) userDidLogOUT:(SMCyUser*)account{
    if([SMCyBusyController isVisible]){
        [SMCyBusyController close];
    }
}


-(void) userDidDeleteAccount:(SMCyUser*)account{
    
}

-(void) userWillTryFetchUserData:(SMCyUser*)account{
    if(![SMCyBusyController isVisible]){
        [SMCyBusyController showOnViewController:self];
    }
}

-(void) userDidFetchUserData:(SMCyUser*)account{
    if([SMCyBusyController isVisible]){
        [SMCyBusyController close];
    }
    [self pushNextView];
}

-(void) userFailedFetchUserData:(SMCyUser*)account{
    if([SMCyBusyController isVisible]){
        [SMCyBusyController close];
    }
}

-(void)pushNextView{
    [[SMCyUser activeUser] removeDelegate:self];
    [self performSegueWithIdentifier:@"loginToReminder" sender:self];
}

@end
