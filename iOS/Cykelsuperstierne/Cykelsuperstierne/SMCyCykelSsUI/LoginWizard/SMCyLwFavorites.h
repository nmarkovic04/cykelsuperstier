//
//  SMCyLwFavorites.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"

@interface SMCyLwFavorites : SMCyBaseVC
@property (weak, nonatomic) IBOutlet UIButton *saveFavoritesButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UITextField *homeAddress;
@property (weak, nonatomic) IBOutlet UITextField *workAddress;

- (IBAction)onSaveFavorites:(UIButton *)sender;
- (IBAction)onSkip:(UIButton *)sender;
@end
