//
//  SMCyRouteSetterVC.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"
#import "SMCyTripRoute.h"

@class SMCyLocation;

@interface SMCyRouteSetterVC : SMCyBaseVC<SMCyRouteDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;

@property (weak, nonatomic) IBOutlet UITableView *favouriteTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;

@property (strong, nonatomic) SMCyLocation * startLocation;
@property (strong, nonatomic) SMCyLocation * endLocation;

- (IBAction)topTextFieldTouch:(UIButton *)sender;
- (IBAction)bottomTextFieldTouch:(UIButton *)sender;

- (IBAction)onStart:(UIButton *)sender;
- (IBAction)onBack:(UIButton *)sender;


@end
