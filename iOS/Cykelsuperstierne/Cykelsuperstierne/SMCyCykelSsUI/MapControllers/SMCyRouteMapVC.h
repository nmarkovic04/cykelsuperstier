//
//  SMCyRouteMap.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseVC.h"
#import "RMMapView.h"
#import "SMCyMainMapVC+Animations.h"
#import "SMCyRoute.h"

@interface SMCyRouteMapVC : SMCyMainMapVC<SMCyRouteDelegate>


- (IBAction)onBreakRoute:(id)sender;
- (IBAction)onClose:(UIButton *)sender;
@end
