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
#import "SMLocationManager.h"
#import "SMCyFavouritesTableViewController.h"
#import "SMCySearchHistoryTableViewController.h"
#import "SMCySearchHistory.h"

#define BOTTOM_MARGIN 15
@interface SMCyRouteSetterVC ()

@property(nonatomic, strong) SMCyTripRoute * route;
@property(nonatomic, strong) SMCySearchHistoryTableViewController* historyVC;
@property(nonatomic, strong) SMCyFavouritesTableViewController* favoritesVC;
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
    
    self.historyVC= [[SMCySearchHistoryTableViewController alloc] init];
    self.historyVC.tableView= self.searchHistoryTableView;
    [self.historyVC setup];

    self.favoritesVC= [[SMCyFavouritesTableViewController alloc] init];
    self.favoritesVC.tableView= self.favouriteTableView;
    [self.favoritesVC setup];
    
    [self.favouriteTableView reloadData];
    [self.searchHistoryTableView reloadData];
    
    self.tableScrollView.scrollEnabled= YES;
    self.tableScrollView.userInteractionEnabled= YES;
    
    [self reloadTables];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.startLocation && self.startLocation.name){
        self.topTextField.text= self.startLocation.name;
    }else{
        
        if([SMLocationManager instance].hasValidLocation){
            self.startLocation= [[SMCyLocation alloc] init];
            self.startLocation.name= @"UserLocation";
            self.startLocation.location= [SMLocationManager instance].lastValidLocation;
            self.topTextField.text= self.startLocation.name;
        }

    }
    
    self.bottomTextField.text= (self.endLocation && self.endLocation.name)?self.endLocation.name:@"";
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

-(void)openAddressFinderForTop:(BOOL)top{
    SMCyAddressFinder * addresFinder = (SMCyAddressFinder*)[SMCyAddressFinder showModalOnViewController:self animated:YES withCompletion:^{
       //do something
    }];
    if(top){
        addresFinder.currentLocation= self.startLocation;
    }else{
        addresFinder.currentLocation= self.endLocation;
    }
    
    addresFinder.completionBlock = ^(SMCyLocation* location){
        if(location){
            if(top){
                self.topTextField.text = location.name;
                self.startLocation = location;
            } else {
                self.bottomTextField.text = location.name;
                self.endLocation = location;
                
                [[SMCySearchHistory instance] addSearchEntityWithLocation:location];
                
                [self reloadTables];
                
                
            }
        }
    };
}

-(void)reloadTables{
    [self.searchHistoryTableView reloadData];
    
    CGRect frm= self.searchHistoryTableView.frame;
    frm.size= self.searchHistoryTableView.contentSize;
    self.searchHistoryTableView.frame= frm;
    
    self.tableScrollView.contentSize= CGSizeMake(self.tableScrollView.frame.size.width, self.searchHistoryTableView.frame.origin.y+self.searchHistoryTableView.frame.size.height+BOTTOM_MARGIN);
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

- (void)viewDidUnload {
    [self setFavouriteTableView:nil];
    [self setSearchHistoryTableView:nil];
    [self setTableScrollView:nil];
    [super viewDidUnload];
}

@end
