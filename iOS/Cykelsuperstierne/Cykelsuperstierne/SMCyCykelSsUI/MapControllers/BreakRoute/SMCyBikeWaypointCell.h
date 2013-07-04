//
//  SMCyBikeCell.h
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/4/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCyBikeWaypointCell : UITableViewCell

-(id)initWithNibNamed:(NSString*)nibName;

@property (weak, nonatomic) IBOutlet UILabel *labelAddressTop;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressBottom;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAB;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBike;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UIView *viewDistance;
-(void)setup;
@end
