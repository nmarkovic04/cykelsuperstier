//
//  SMCyLwFirstTimeIntro.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"

@interface SMCyLwFirstTimeIntro : SMCyBaseVC
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

- (IBAction)onExit:(UIButton *)sender;
@end
