//
//  SMCyRouteSetterVC.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRouteSetterVC.h"
#import "SMCyAddressFinder.h"
#import "SMCyLocation.h"
#import "SMCyTripRoute.h"
#import "SMCyBusyController.h"
#import "SMCyUser.h"

@interface SMCyRouteSetterVC ()
@property(nonatomic, strong) SMCyTripRoute * route;
@end

@implementation SMCyRouteSetterVC

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

- (IBAction)topTextFieldTouch:(UIButton *)sender{
    [self openAddressFinderForTop:YES];
}

- (IBAction)bottomTextFieldTouch:(UIButton *)sender{
    [self openAddressFinderForTop:NO];
}

- (IBAction)onStart:(UIButton *)sender {
    
    [SMCyBusyController showOnViewController:self];
    [self prepareRoute];

}

- (IBAction)onBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) prepareRoute{
    self.route = nil;
    if(!self.startLocation || !self.endLocation){
        [SMCyBusyController close];
        return;
    }
    
    self.route = [[SMCyTripRoute alloc] initWithStart:self.startLocation end:self.endLocation andDelegate:self];
    [SMCyUser activeUser].activeRoute= self.route;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

-(void)openAddressFinderForTop:(BOOL)top{
    SMCyAddressFinder * addresFinder = (SMCyAddressFinder*)[SMCyAddressFinder showModalOnViewController:self animated:YES withCompletion:^{
       //do something
    }];
    
    addresFinder.completionBlock = ^(SMCyLocation* location){
        if(location){
            if(top){
                self.topTextField.text = location.name;
                self.startLocation = location;
            } else {
                self.bottomTextField.text = location.name;
                self.endLocation = location;
            }
        }
    };
}

#pragma mark - route delegate methods

-(void)routeStateChanged:(SMCyRoute*)route{
    if(route.state == RS_FAILED_SEARCHING_FOR_ROUTE || route.state == RS_READY){
        [SMCyBusyController close];
        if(self.route){
            [self performSegueWithIdentifier:@"routeSetterToRouteMap" sender:self];
        }
    }
}

@end
