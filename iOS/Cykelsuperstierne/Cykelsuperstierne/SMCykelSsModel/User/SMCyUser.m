//
//  SMCycelUser.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyUser.h"
#import "SMrUtil.h"
#import "SMCyConsts.h"
#import "SMCyAPIWrapper.h"
#import "Base64.h"
#import "SFHFKeychainUtils.h"


#define DELEGATE_NOTIFY(_notification_) trt


@interface SMCyUser()
@property (nonatomic, strong, readwrite) SMCyAccount * account;
@property (nonatomic, strong, readwrite) NSMutableArray * delegates;
@end

@implementation SMCyUser

#pragma mark - getters / setters


- (NSString *)name{
    return _name;
}

- (NSString *)email{
    return _email;
}

- (NSString *)about{
    return _about;
}

- (NSString *)role{
    return _role;
}

- (NSString *)img_url{
    return _img_url;
}


- (NSString *)authorisation_token{
    return _authorisation_token;
}

- (NSString *)user_id {
    return _user_id;
}

- (eAccountType)accountType{
    if(self.account) return self.account.accountType;
    return AT_UNKNOWN;
}

- (void)setAccountType:(eAccountType)accountType{
    if(accountType == self.accountType) return;
    
    if(self.account){
        [self.account logout];
        self.account = nil;
    }
    
    if(accountType != AT_UNKNOWN){
        self.account = [SMCyAccount createAccountOfType:accountType WithDelegate:self];
    }
}

- (SMrURLImage *)image{
    if(!_image){
        _image = [[SMrURLImage alloc] initWithDelegate:nil ImageURL:self.img_url];
        if(self.img_url) [_image prepareBackImage];
    }
    return _image;
}

#pragma mark -
-(void) addDelegate:(id<SMCyUserDelegate>)delegate{
    
}

-(void) removeDelegate:(id<SMCyUserDelegate>)delegate{
    
}


-(BOOL) isLoggedin{
    return (self.authorisation_token && self.user_id);
}

-(BOOL) isDataLocked{
    if(self.account){
        return [self.account isUserDataLocked];
    }
    return YES;
}

-(BOOL)login{
    return NO;
}

-(BOOL)logout{
    return NO;
}

-(BOOL)deleteAccount{
    return NO;
}

-(BOOL) saveToFileNamed:(NSString*)fileName{
    NSString * path = [SMrUtil getCachePathForFile:fileName];
    [self.account saveToCache:[path stringByAppendingPathExtension:@"acc"]];
   
    NSMutableDictionary * data = [NSMutableDictionary new];
    
    [data setValue:self.name forKey:@"name"];
    [data setValue:self.email forKey:@"email"];
    [data setValue:self.about forKey:@"about"];
    [data setValue:self.role forKey:@"role"];
    [data setValue:self.img_url forKey:@"img_url"];
    [data setValue:self.user_id forKey:@"user_id"];
    [data setValue:[NSNumber numberWithInt:self.accountType] forKey:@"accountType"];
    
    if(self.image.isUrlImageReady){
        [data setValue:self.image.urlImage forKey:@"user_image"];
    }
    
    [NSKeyedArchiver archiveRootObject:data toFile:[path stringByAppendingPathExtension:@"usr"]];
    
    NSError * err;
    if(self.authorisation_token && self.user_id){
        [SFHFKeychainUtils storeUsername:self.user_id andPassword:self.authorisation_token forServiceName:KEY_AUTHORISATION updateExisting:NO error:&err];
    }
    
    if([self isLoggedin]){
        return YES;
    }
    
    if(self.account && [self.account isLoggedin]){
        [[SMCyAPIWrapper sharedInstance] loginUser:self];
    } else if(self.account){
        [self.account login];
    }
    
    return YES;
}

-(BOOL) loadFromFileNamed:(NSString*)fileName{
    NSString * path = [SMrUtil getCachePathForFile:fileName];
    NSDictionary * data;
    
    data = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathExtension:@"usr"]];
    if(!data) return NO;
    
    
    _name = [data valueForKey:@"name"];
    _email = [data valueForKey:@"email"];
    _about = [data valueForKey:@"about"];
    _role = [data valueForKey:@"role"];
    _img_url = [data valueForKey:@"img_url"];
    _user_id = [data valueForKey:@"user_id"];
    
    self.accountType = [[data valueForKey:@"accountType"] integerValue];
    
    UIImage * img = [data valueForKey:@"user_image"];
    _image = [[SMrURLImage alloc] initWithDelegate:nil ImageURL:self.img_url andDefaultImage:img];
    [_image prepareBackImage];
    
     NSError * err;
    _authorisation_token = [SFHFKeychainUtils getPasswordForUsername:self.user_id andServiceName:KEY_AUTHORISATION error:&err];
    
    [self.account loadFromCache:[path stringByAppendingPathExtension:@"acc"]];
    
    return YES;
}

-(NSString*) getImageAsBase64EncodedString{
    //TODO: Finish
    if(self.image.isUrlImageReady){
        NSData * imgData = UIImageJPEGRepresentation(self.image.urlImage, 1.0);
        if(imgData){
            return [imgData base64EncodedString];
        }
    }
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL) isActiveUser{
    return self == [SMCyUser activeUser];
}

+(SMCyUser*) activeUser{
    static SMCyUser * activeUser = nil;
    if(!activeUser){
        activeUser = [SMCyUser new];
        [activeUser loadFromFileNamed:KEY_ACTIVEUSER_FILENAME];
        [[NSNotificationCenter defaultCenter] addObserver:activeUser selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return activeUser;
}
 

-(void) appWillResignActive:(NSNotification*)notification{
    if(self != [SMCyUser activeUser]) return ;
    [self saveToFileNamed:KEY_ACTIVEUSER_FILENAME];
}


#pragma mark - account delegate methods

-(void) accountDidLogIN:(SMCyAccount*)account{
}

-(void) accountFailedToLogIN:(SMCyAccount*)account{
}

-(void) accountDidLogOUT:(SMCyAccount*)account{
}

-(void) accountDidFetchUserData:(SMCyAccount*)account{
}

-(void) accountDidFetchUserImage:(SMCyAccount*)account{
}


@end
