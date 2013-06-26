//
//  SMCykelFacebookAccount.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyFacebookAccount.h"
#import <FacebookSDK/FacebookSDK.h>


#define RETURN_NIL_IF_NOT_LOGGED_IN if(![self isLoggedin]) return nil;


@interface SMCyFacebookAccount(){
    NSString * _userId;
    NSString * _alias;
    NSString * _firstName;
    NSString * _lastName;
    NSString * _email;
    NSString * _authenticationToken;
    UIImage * _image;
}

@property(nonatomic, strong, readonly) FBSession * fbSession;

@end



@implementation SMCyFacebookAccount

- (FBSession *)fbSession{
    return [FBSession activeSession];
}

- (id)init{
    self = [super init];
    
    if(self){
//self.fbSession = [[FBSession alloc] initWithAppID:FB_APP_ID permissions:[NSArray arrayWithObject:@"email"] urlSchemeSuffix:[@"fb" stringByAppendingString:FB_APP_ID] tokenCacheStrategy:nil];
        
        //TODO: check if active session is open
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)authenticationToken{
    if(![self isLoggedin]) return nil;
    return self.fbSession.accessTokenData.accessToken;
}

- (NSString *)userId{
    return  _userId;
}


- (void)setAuthenticationToken:(NSString *)authenticationToken{
    _authenticationToken = authenticationToken;
}

- (eAccountType)accountType{
    return AT_FACEBOOK;
}

- (eAuthenticationType)authenticationType{
    return AuT_TOKEN;
}

-(BOOL) isLoggedin{
    return self.fbSession.accessTokenData != nil;
}
-(void) login{
    
    [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
//    if(![self.fbSession isOpen]){
//        [self.fbSession openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//            [self sessionStateChanged:session state:state error:error];
//        }];
//    }
}

- (void)logout{
    [self.fbSession closeAndClearTokenInformation];
//    [self notifyDelegateLoggedOUT];
}

- (BOOL)loadFromCache:(NSString *)filePath{
    //check if we are already logged in
    return [self isLoggedin];
}

- (BOOL)saveToCache:(NSString *)filePath{
    //this is dona automatically by FacebookSDK
    return YES;
}

-(BOOL) isUserDataLocked{
    return YES;
}

-(NSString*)alias{
    return _alias;
}

-(NSString*)firstName{
    return _firstName;
}

-(NSString*)lastName{
    return _lastName;
}

-(NSString*)email{
    return _email;
}

-(UIImage*)image{
    return _image;
}

#pragma mark - FB
-(void)appDidBecomeActive:(NSNotification*)notification{
    [self.fbSession handleDidBecomeActive];
}

-(void)appDidFinishLaunching:(NSNotification*)notification{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        //logged in
        [self login];
    } else {
        // not logged in
    }
}

-(void)createAndActivateNewSession{
    
    FBSession * fbs = [FBSession activeSession];
    
    fbs = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObject:@"email"]];
    [FBSession setActiveSession:fbs];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            //session is open -> fetch user data
            if([self isLoggedin]){
                [self notifyDelegateLoggedIN]; //checking just in case :)
            }
            [self fetchUserData];
            break;
        case FBSessionStateClosed:
            [self notifyDelegateLoggedOUT];
            break;
        case FBSessionStateClosedLoginFailed:
            [self notifyDelegateFailedToLogIN];
            break;
        default:
            break;
    }
}

-(BOOL) fetchUserData{
    FBRequest * request = [FBRequest requestForMe];
    if(!request) return NO;
    
    __weak SMCyFacebookAccount * localSelfCopy = self;
    [request startWithCompletionHandler:^(FBRequestConnection * connection, NSDictionary<FBGraphUser> * result, NSError * err){
        if(!err){
            _alias = result.username;
            _firstName = result.first_name;
            _lastName = result.last_name;
            _userId = result.id;
            [localSelfCopy notifyDelegateFetchedUserData];
        } else {
            [localSelfCopy notifyDelegateFetchedUserDataFailed];
        }
        
    }];
    
    return YES;
}

-(BOOL) fetchUserImage{
    //TODO: finish
    return NO;
}

#pragma mark - static


+(void)initialize{
    SMCyFacebookAccount* defaultAcc = [SMCyFacebookAccount defaultAccount];
    [defaultAcc createAndActivateNewSession];
}

+(SMCyFacebookAccount*)defaultAccount{
    static SMCyFacebookAccount * _defaultAccount = nil;
    @synchronized(self){
        if(!_defaultAccount){
            _defaultAccount = [SMCyFacebookAccount new];
            [[NSNotificationCenter defaultCenter] addObserver:_defaultAccount selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:_defaultAccount selector:@selector(appDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
        }
    }
    return _defaultAccount;
}


@end
