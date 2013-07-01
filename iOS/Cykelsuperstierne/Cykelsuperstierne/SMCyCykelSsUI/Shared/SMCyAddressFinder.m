//
//  SMCyAddressFinder.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyAddressFinder.h"
#import "SMCySearchAdressCell.h"
#import "SMCyLocation.h"


@interface SMCyAddressFinder ()
@property(nonatomic, strong) SMAutocomplete * autoComplete;
@property(nonatomic, strong) NSMutableArray * foundLocations;
@property(nonatomic, strong) NSString * currentSearchText;
@end

@implementation SMCyAddressFinder

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
    // Do any additional setup after loading the view from its nib.
}

- (SMAutocomplete *)autoComplete{
    if(!_autoComplete){
        _autoComplete = [[SMAutocomplete alloc] initWithDelegate:self];
    }
    return _autoComplete;
}

-(NSMutableArray *)foundLocations{
    if(!_foundLocations){
        _foundLocations = [NSMutableArray new];
    }
    return _foundLocations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(UIButton *)sender {
    [self backCloseAnimated:YES withCompletion:nil];
}

- (IBAction)onTextChanged:(UITextField *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(sender.text.length > 1){
        [self performSelector:@selector(searchFor:) withObject:sender.text afterDelay:0.5];
        self.currentSearchText = sender.text;
    } else{
        if(self.currentSearchText && self.currentSearchText.length>1){
            //TODO: clear search results
        }
        self.currentSearchText = nil;
    }
    
}

- (IBAction)onEditEnded:(UITextField *)sender {
    
}

- (IBAction)onEditBegun:(UITextField *)sender {
}

-(void) searchFor:(NSString*)txt{
    [self.foundLocations removeAllObjects];
    [self.autoComplete getAutocomplete:txt];
    [self searchRecentFor:txt];
    [self searchFavoritesFor:txt];
}

-(void) searchRecentFor:(NSString*)txt{
    
}

-(void) searchFavoritesFor:(NSString*)txt{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchField resignFirstResponder];
    return YES;
}



#pragma mark - SMAutocompleteDelegate methods

- (void)autocompleteEntriesFound:(NSArray*)arr forString:(NSString*) str{
    if(![str isEqualToString:self.currentSearchText]){
        return;
    }
    for(NSDictionary * data in arr){
        [self.foundLocations addObject:[[SMCyLocation alloc] initWithDictionary:data]];
    }
    if(self.foundLocations.count > 0) {
        [self.resultsTable reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.foundLocations.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SMCySearchAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [SMCySearchAdressCell loadFromNibForOwner:self];
    }
    // Configure the cell...
    if(self.foundLocations && self.foundLocations.count > indexPath.row){
        [cell setupWithLocation:[self.foundLocations objectAtIndex:indexPath.row]];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.completionBlock && self.foundLocations && self.foundLocations.count > indexPath.row){
        self.completionBlock([self.foundLocations objectAtIndex:indexPath.row]);
    }
    
    [self backCloseAnimated:YES withCompletion:nil];
}


@end
