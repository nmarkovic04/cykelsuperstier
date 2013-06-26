//
//  SMCycelUser.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCyAccount.h"
#import "SMrURLImage.h"

@class SMCyUser;

@protocol SMCyUserDelegate <NSObject>
@optional
-(void) userDidLogIN:(SMCyAccount*)account;
-(void) userFailedToLogIN:(SMCyAccount*)account;
-(void) userDidLogOUT:(SMCyAccount*)account;
-(void) userDidDeleteAccount:(SMCyAccount*)account;
-(void) userDidFetchUserData:(SMCyAccount*)account;
-(void) userDidFetchUserImage:(SMCyAccount*)account;
@end




@interface SMCyUser : NSObject<SMCyAccountDelegate>{
@private
    NSString * _name;
    NSString * _email;
    NSString * _about;
    NSString * _role;
    NSString * _img_url;
    NSString * _authorisation_token;
    NSString * _user_id;
    SMrURLImage * _image;
}

@property (nonatomic, strong, readonly) NSArray * delegates;
@property (nonatomic, strong, readonly) NSString * name;
@property (nonatomic, strong, readonly) NSString * email;
@property (nonatomic, strong, readonly) NSString * about;
@property (nonatomic, strong, readonly) NSString * role;
@property (nonatomic, strong, readonly) NSString * img_url;
@property (nonatomic, strong, readonly) NSString * authorisation_token;
@property (nonatomic, strong, readonly) NSString * user_id;
@property (nonatomic, strong, readonly) SMCyAccount * account;
@property (nonatomic, strong, readonly) SMrURLImage * image;
@property (nonatomic, assign) eAccountType accountType;

-(void) addDelegate:(id<SMCyUserDelegate>)delegate;
-(void) removeDelegate:(id<SMCyUserDelegate>)delegate;

-(BOOL) isLoggedin;
-(BOOL) isDataLocked;

-(BOOL)login;
-(BOOL)logout;
-(BOOL)deleteAccount;

-(BOOL) saveToFileNamed:(NSString*)fileName;
-(BOOL) loadFromFileNamed:(NSString*)fileName;

-(NSString*) getImageAsBase64EncodedString;

+(SMCyUser*) activeUser;

@end
