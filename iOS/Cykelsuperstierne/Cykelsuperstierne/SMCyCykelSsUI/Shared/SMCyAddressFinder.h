//
//  SMCyAddressFinder.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseSharedVC.h"
#import "SMAutocomplete.h"
#import "SMCyLocation.h"

@interface SMCyAddressFinder : SMCyBaseSharedVC<SMAutocompleteDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

typedef void(^SMCyAddressSearchCompletion)(SMCyLocation*);

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong, nonatomic) SMCyAddressSearchCompletion completionBlock;


- (IBAction)onCancel:(UIButton *)sender;

- (IBAction)onTextChanged:(UITextField *)sender;
- (IBAction)onEditEnded:(UITextField *)sender;
- (IBAction)onEditBegun:(UITextField *)sender;

@end
