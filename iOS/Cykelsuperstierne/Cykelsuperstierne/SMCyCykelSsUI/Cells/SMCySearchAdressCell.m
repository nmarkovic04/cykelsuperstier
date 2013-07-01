//
//  SMCySearchAdressCell.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySearchAdressCell.h"
#import "SMCyLocation.h"

@implementation SMCySearchAdressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setupWithLocation:(SMCyLocation*)location{
    self.label.text = location.name;
}

+(SMCySearchAdressCell*)loadFromNibForOwner:(UIViewController*)owner{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"SMCySearchAdressCell" owner:owner options:nil];
    UIView * top = [views objectAtIndex:0];
    if([top isKindOfClass:[SMCySearchAdressCell class]]) {
     return (SMCySearchAdressCell*)top;
    }
    
    return nil;
}

@end
