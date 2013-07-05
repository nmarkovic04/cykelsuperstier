//
//  SMCyBreakRouteVC.m
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/4/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBreakRouteVC.h"
#import "SMCyUser.h"
#import "SMCyBikeWaypointCell.h"
@interface SMCyBreakRouteVC ()

@end

@implementation SMCyBreakRouteVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tripRoute= (SMCyTripRoute*)[SMCyUser activeUser].activeRoute;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tripRoute.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *WaypointCellIdentifier = @"WaypointCell";
    SMCyBikeWaypointCell *cell = [tableView dequeueReusableCellWithIdentifier:WaypointCellIdentifier];
    if (cell == nil) {
        cell = [[SMCyBikeWaypointCell alloc] init];
    }
    
    cell.labelDistance.text= @"Distance 2 km."; 
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)onBreakRoute:(id)sender {
}

-(void)routeStateChanged:(SMCyRoute*)route{
    NSLog(@"Did break route");
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setButtonBreakRoute:nil];
    [self setLabelHeader:nil];
    [super viewDidUnload];
}
@end
