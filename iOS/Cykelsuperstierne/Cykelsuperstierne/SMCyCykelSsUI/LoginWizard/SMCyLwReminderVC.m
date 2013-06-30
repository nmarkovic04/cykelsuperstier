//
//  SMCyReminderVC.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyLwReminderVC.h"
#import "SMCySettings.h"

@interface SMCyLwReminderVC ()

@end

@implementation SMCyLwReminderVC

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

- (IBAction)saveReminder:(UIButton *)sender {
    SMCySettings * settings = [SMCySettings sharedInstance];
    
    [settings setReminder:self.swMonday.isOn forDay:MONDAY];
    [settings setReminder:self.swTuesday.isOn forDay:TUESDAY];
    [settings setReminder:self.swWednesday.isOn forDay:WEDNESDAY];
    [settings setReminder:self.swThursday.isOn forDay:THURSDAY];
    [settings setReminder:self.swFriday.isOn forDay:FRIDAY];
    
    [settings saveToFileNamed:nil];
    
    [self goToNextView];
}

- (IBAction)skip:(UIButton *)sender {
    [self goToNextView];
}

- (void) goToNextView{
    [self performSegueWithIdentifier:@"reminderToFavorites" sender:self];
}
@end
