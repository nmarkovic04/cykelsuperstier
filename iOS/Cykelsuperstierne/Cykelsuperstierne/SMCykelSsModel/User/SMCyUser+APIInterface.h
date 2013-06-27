//
//  SMCyUser+APIInterface.h
//  testAPIRequests
//
//  Created by Rasko on 6/23/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyUser.h"

@interface SMCyUser (APIInterface)

-(NSDictionary*) getLoginDictionary;
-(NSDictionary*) getSignupDictionary;
-(NSDictionary*) getLoggedUserDictionary;
-(NSDictionary*) getUpdateUserDictionary;

-(void) onLoginUserWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data;
-(void) onGetUserDataWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data;
-(void) onDeleteUserWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data;
-(void) onChangeUserDataWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data;



@end
