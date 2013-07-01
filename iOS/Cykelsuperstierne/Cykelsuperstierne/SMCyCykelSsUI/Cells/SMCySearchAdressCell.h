//
//  SMCySearchAdressCell.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMCyLocation;

@interface SMCySearchAdressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

-(void) setupWithLocation:(SMCyLocation*)location;

+(SMCySearchAdressCell*)loadFromNibForOwner:(UIViewController*)owner;

@end
