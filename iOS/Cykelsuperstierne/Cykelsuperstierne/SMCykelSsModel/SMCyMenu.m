//
//  SMCyMenu.m
//  Cykelsuperstierne
//
//  Created by Rasko on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMenu.h"
#import "SMrUtil.h"

@interface SMCyMenu ()

@end

@implementation SMCyMenu

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


+(SMCyMenu*)sharedInstance{
    static SMCyMenu* sharedInstance = nil;
    if(!sharedInstance){
        sharedInstance = [SMCyMenu new];
    }
    return sharedInstance;
}

-(void)notifyDelegateMapSelectionChanged{
    [SMrUtil notifyDelegate:self.delegate WithSelector:@selector(mapMenuSelectionChanged:) AndObject:self];
}

-(void)notifyDelegateDidAddNewFavorite{
    [SMrUtil notifyDelegate:self.delegate WithSelector:@selector(userMenuDidAddNewFavorite:) AndObject:self];
}

-(void)notifyDelegateProfileClicked{
    [SMrUtil notifyDelegate:self.delegate WithSelector:@selector(userMenuProfileClicked:) AndObject:self];
}

-(void)notifyDelegateAboutClicked{
    [SMrUtil notifyDelegate:self.delegate WithSelector:@selector(userMenuAboutClicked:) AndObject:self];
}


@end
