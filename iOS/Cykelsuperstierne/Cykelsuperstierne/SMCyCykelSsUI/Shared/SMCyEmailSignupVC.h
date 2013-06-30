//
//  SMCyEmailSignupVC.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCyBaseSharedVC.h"
#import "SMrDSImageView.h"

@interface SMCyEmailSignupVC : SMCyBaseSharedVC

@property (weak, nonatomic) IBOutlet UIButton *backCloseButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;


@property (weak, nonatomic) IBOutlet SMrDSImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *emailConfirmationField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationField;


- (IBAction)onBackClose:(UIButton *)sender;
- (IBAction)onSignup:(UIButton *)sender;

@end
