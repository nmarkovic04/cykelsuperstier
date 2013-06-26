//
//  SMCykelAPIWrapper.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/21/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMCyUser;

@interface SMCyAPIWrapper : NSObject

// user stuff
-(BOOL) loginUser:(SMCyUser*)user;
-(BOOL) deleteUser:(SMCyUser*)user;
-(BOOL) getUser:(SMCyUser*)user;
-(BOOL) changeUserData:(SMCyUser*)user;

+(SMCyAPIWrapper*) sharedInstance;

@end
