//
//  SMCyUser+APIInterface.m
//  testAPIRequests
//
//  Created by Rasko on 6/23/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyUser+APIInterface.h"
#import "SMCyAPIVocabular.h"
#import "SMCyAPIWrapper.h"
#import "SMrUtil.h"

@implementation SMCyUser (APIInterface)

-(NSDictionary*) getLoginDictionary{
    if(![self.account isLoggedin]) return nil;
    
    NSMutableDictionary * ret = [NSMutableDictionary new];
    NSMutableDictionary * user = [NSMutableDictionary new];
    
    switch (self.account.authenticationType) {
        case AuT_ALIAS_PASSWORD:
            [user setValue:self.account.alias forKey: API_KEY_ALIAS ];
            [user setValue:self.account.password  forKey:API_KEY_PASSWORD];
            break;
        case AuT_EMAIL_PASSWORD:
            [user setValue:self.account.email  forKey:API_KEY_EMAIL];
            [user setValue:self.account.password  forKey:API_KEY_PASSWORD];
            break;
        case AuT_FIRSTNAME_PASSWORD:
            [user setValue:self.account.firstName  forKey:API_KEY_USER_NAME];
            [user setValue:self.account.password  forKey:API_KEY_PASSWORD];
            break;
        case AuT_TOKEN:
            if(self.account.accountType == AT_FACEBOOK){
                [user setValue:self.account.authenticationToken forKey: API_KEY_FACEBOOK_TOKEN];
            } else {
                [user setValue:self.account.authenticationToken forKey: API_KEY_DEFAULT_AUTH_TOKEN];
            }
            break;
        default:
            return nil;
            break;
    }
    
    [ret setValue:user forKey:API_KEY_USER];
    return ret;
}

-(NSDictionary*) getSignupDictionary{
    if(![self isLoggedin]) return nil;
    
    NSMutableDictionary * ret = [NSMutableDictionary new];
    NSMutableDictionary * user = [NSMutableDictionary new];
    if(self.account.authenticationType == AuT_TOKEN){
        if(self.account.accountType == AT_FACEBOOK){
            [user setValue:API_KEY_FACEBOOK_TOKEN forKey:self.account.authenticationToken];
        } else {
            [user setValue:API_KEY_DEFAULT_AUTH_TOKEN forKey:self.account.authenticationToken];
        }
    } else {
        user = [self getFullUserData];
    }

[ret setValue:user forKey:API_KEY_USER];

return ret;

}

-(NSDictionary*) getLoggedUserDictionary{
    if(![self isLoggedin]) return nil;
    NSMutableDictionary * ret = [@{API_KEY_AUTHORISATION_TOKEN : self.authorisation_token} mutableCopy];
    return ret;
}

-(NSDictionary*) getUpdateUserDictionary{
    if(![self isLoggedin]) return nil;
    NSMutableDictionary * ret = [@{
                                 API_KEY_AUTHORISATION_TOKEN : self.authorisation_token,
                                 API_KEY_USER_ID : self.user_id} mutableCopy];
    NSMutableDictionary * user = [self getFullUserData];
    [ret setValue:user forKey:API_KEY_USER];
    
    return ret;
}

-(NSMutableDictionary *) getFullUserData{
    NSMutableDictionary * user = [NSMutableDictionary new];
    [user setValue:self.account.firstName forKey:API_KEY_USER_NAME];
    [user setValue:self.account.email forKey:API_KEY_EMAIL];
    [user setValue:self.account.email forKey:API_KEY_EMAILCONFIRMATION];
    [user setValue:self.account.password forKey:API_KEY_PASSWORD];
    [user setValue:self.account.password forKey:API_KEY_PASSWORDCONFIRMATION];
    
    NSMutableDictionary * img = [NSMutableDictionary new];
    [img setValue:[self getImageAsBase64EncodedString] forKey:API_KEY_FILE];
    [img setValue:@"image.jpg" forKey:API_KEY_FILENAME];
    [img setValue:@"image.jpg" forKey:API_KEY_ORIGINAL_FILENAME];
    [user setValue:img forKey:API_KEY_IMAGE_PATH];
    
    [user setValue:APP_CODENAME forKey:API_KEY_ACCOUNT_SOURCE];
    return user;
}

#pragma mark - API responses

-(void) onLoginUserWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data{
    //TODO: finish (notify delegate, etc.)
    if(success){
//        _firstName = [data valueForKey:API_KEY_USER_NAME];
        _user_id = [[data valueForKey:API_KEY_USER_ID] stringValue];
        _authorisation_token = [data valueForKey:API_KEY_AUTHORISATION_TOKEN];
        [self notifyDelegatesDidLogIN];
        [[SMCyAPIWrapper sharedInstance] getUser:self];
    } else {
        
    }
    
}

-(void)startNewImageDownload{
    if(self.img_url){
        self.image.imageUrl = self.img_url;
//        if(self.image.isUrlImageInFront){
//            self.image.backImage = self.image.frontImage;
//            [self.image swap];
//        }
        [self.image prepareBackImage];
    }
}

-(void) onGetUserDataWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data{
    
    if(success){
        _about = [data valueForKey:API_KEY_USER_ABOUT];
        _email = [data valueForKey:API_KEY_EMAIL];
        _name =  [data valueForKey:API_KEY_USER_NAME];
        _role = [data valueForKey:API_KEY_USER_ROLE];
        _img_url = [data valueForKey:API_KEY_IMAGE_URL];
        [self startNewImageDownload];
        [self notifyDelegatesDidFetchUserData];
    } else {
        //should we sent failed notification ?
    }
    
}

-(void) onDeleteUserWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data{
    NSLog(@"onDeleteUserWithSuccess : %@", info);
}

-(void) onChangeUserDataWithSuccess:(BOOL) success Info:(NSString*)info Errors:(NSString*)errors AndData:(NSDictionary*) data{
    
    SMCyAPIWrapper * api = [SMCyAPIWrapper sharedInstance];
    
    if(success){
        [api getUser:self];
    }
    
    NSLog(@"onChangeUserDataWithSuccess : %@", info);
}



#pragma mark - delegate notification utils

-(void)notifyDelegatesDidLogIN{
    [self notifyDelegatesWithSelector:@selector(userDidLogIN:)];
}
-(void)notifyDelegatesFailedToLogIN{
    [self notifyDelegatesWithSelector:@selector(userFailedToLogIN:)];
}
-(void)notifyDelegatesDidLogOUT{
    [self notifyDelegatesWithSelector:@selector(userDidLogOUT:)];
}
-(void)notifyDelegatesDidDeleteAccount{
    [self notifyDelegatesWithSelector:@selector(userDidDeleteAccount:)];
}
-(void)notifyDelegatesDidFetchUserData{
    [self notifyDelegatesWithSelector:@selector(userDidFetchUserData:)];
}
-(void)notifyDelegatesDidFetchUserImage{
    [self notifyDelegatesWithSelector:@selector(userDidFetchUserImage:)];
}

-(void) notifyDelegatesWithSelector:(SEL)sel{
    [SMrUtil notifyOnMainThreadDelegatesList:self.delegates WithSelector:sel AndObject:self];
}

@end
