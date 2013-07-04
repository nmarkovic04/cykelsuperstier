//
//  SMCyBreakRouteVC.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/4/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCyTripRoute.h"
#import "SMCyBaseVC.h"

@interface SMCyBreakRouteVC : SMCyBaseVC<UITableViewDataSource, UITableViewDelegate,SMCyRouteDelegate>

@property(nonatomic, strong) SMCyTripRoute* tripRoute;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBreakRoute;
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;

@end
