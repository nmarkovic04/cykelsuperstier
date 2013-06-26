//
//  SMCykelAccount.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _eAccountType {
    AT_UNKNOWN,
    AT_FACEBOOK,
    AT_EMAIL
} eAccountType;

typedef enum _eAuthenticationType {
    AuT_UNKNOWN,
    AuT_TOKEN,
    AuT_EMAIL_PASSWORD,
    AuT_ALIAS_PASSWORD,
    AuT_FIRSTNAME_PASSWORD
} eAuthenticationType;

@class SMCyAccount;

@protocol SMCyAccountDelegate <NSObject>
@optional
-(void) accountDidLogIN:(SMCyAccount*)account;
-(void) accountFailedToLogIN:(SMCyAccount*)account;
-(void) accountDidLogOUT:(SMCyAccount*)account;
-(void) accountFailedToLogOUT:(SMCyAccount*)account;
-(void) accountDidFetchUserData:(SMCyAccount*)account;
-(void) accountFetchUserDataFailed:(SMCyAccount*)account;
-(void) accountDidFetchUserImage:(SMCyAccount*)account;
-(void) accountFetchUserImageFailed:(SMCyAccount*)account;
@end

@interface SMCyAccount : NSObject

@property(nonatomic, weak) id<SMCyAccountDelegate> delegate;
@property(nonatomic, readonly) eAccountType accountType;
@property(nonatomic, readonly) eAuthenticationType authenticationType;
@property(nonatomic, strong, readonly) NSString * authenticationToken;
@property(nonatomic, strong, readonly) NSString * userId;
@property(nonatomic, strong) NSString * password;

-(BOOL) isLoggedin;
-(void) login;
-(void) logout;
-(BOOL) fetchUserData;
-(BOOL) fetchUserImage;
-(BOOL) saveToCache:(NSString *)filePath;
-(BOOL) loadFromCache:(NSString *)filePath;
-(BOOL) isUserDataLocked;


-(NSString*)alias;
-(void)setAlias:(NSString*)alias;

-(NSString*)firstName;
-(void)setFirstName:(NSString*)firstName;

-(NSString*)lastName;
-(void)setLastName:(NSString*)lastName;

-(NSString*)email;
-(void)setEmail:(NSString*)email;

-(UIImage*)image;
-(void)setImage:(UIImage*)image;



+(SMCyAccount*)createAccountOfType:(eAccountType)type WithDelegate:(id<SMCyAccountDelegate>) delegate;

@end
