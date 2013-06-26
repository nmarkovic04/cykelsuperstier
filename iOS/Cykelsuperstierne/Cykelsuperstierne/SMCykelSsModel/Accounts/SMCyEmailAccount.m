//
//  SMCykelEmailAccount.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyEmailAccount.h"
#import "SMCyConsts.h"
#import "SFHFKeychainUtils.h"

@interface SMCyEmailAccount(){
    NSString * _password;
    NSString * _alias;
    NSString * _firstName;
    NSString * _lastName;
    NSString * _email;
    UIImage * _image;
}
@end

@implementation SMCyEmailAccount

- (eAccountType)accountType{
    return AT_EMAIL;
}

- (eAuthenticationType)authenticationType{
    return AuT_EMAIL_PASSWORD;
}

-(BOOL) isLoggedin{
    return (self.email && self.password);
}

- (void)login{
    // nothing to do here ... only password & email should be set
    if([self isLoggedin]){
        [self notifyDelegateLoggedIN];
    } else {
        [self notifyDelegateFailedToLogIN];
    }
}

- (void)logout{
    BOOL prevLogged = [self isLoggedin];
    [self cleanData];
    if(prevLogged) [self notifyDelegateLoggedOUT];
    else         [self notifyDelegateFailedToLogOUT];
}
//
//-(BOOL) fetchUserData{
//    return NO;
//}
//
//-(BOOL) fetchUserImage {
//    return NO;
//}

-(void) cleanData{
    self.alias = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.password = nil;
    self.email = nil;
    self.image = nil;
}

- (BOOL)loadFromCache:(NSString *)filePath{
    [self cleanData];
    NSDictionary * savedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if(!savedData && ![savedData isKindOfClass:[NSDictionary class]]) return NO;
    
    for(NSString * key in savedData.allKeys){
        if([self respondsToSelector:NSSelectorFromString(key)]){
            [self setValue:[savedData valueForKey:key] forKey:key];
        }
    }
    NSError * err;
    self.password = [SFHFKeychainUtils getPasswordForUsername:self.email andServiceName:KEY_AUTHORISATION error:&err];
    return YES;
}

- (BOOL)saveToCache:(NSString *)filePath{
    //password won't be saved
    NSMutableDictionary * forSave = [@{@"alias"     : self.alias?self.alias:@"",
                                     @"firstName"   : self.firstName?self.firstName:@"",
                                     @"lastName"    : self.lastName?self.lastName:@"",
                                     @"email"       : self.email?self.email:@""} mutableCopy];
    
    if(self.image)[forSave setValue:self.image forKey:@"image"];
    
    NSError * err;
    [SFHFKeychainUtils storeUsername:self.email andPassword:self.password forServiceName:KEY_AUTHORISATION updateExisting:NO error:&err];
    
    return [NSKeyedArchiver archiveRootObject:forSave toFile:filePath];
}

-(BOOL) isUserDataLocked{
    return NO;
}

-(NSString*)alias{
    return _alias;
}

-(void)setAlias:(NSString*)alias{
    _alias = alias;
}

-(NSString*)firstName{
    return _firstName;
}

-(void)setFirstName:(NSString*)firstName{
    _firstName = firstName;
    
    if([ self isThereEnoughUserData]){
        [self notifyDelegateFetchedUserData];
    }
}

-(NSString*)lastName{
    return _lastName;
}

-(void)setLastName:(NSString*)lastName{
    _lastName = lastName;
}

-(NSString*)email{
    return _email;
}

-(void)setEmail:(NSString*)email{
    BOOL prevStatus = [self isLoggedin];
    _email = email;
    if([self isLoggedin]){
        if(prevStatus) [self notifyDelegateLoggedOUT];
        [self notifyDelegateLoggedIN];
    }
    
    if([ self isThereEnoughUserData]){
        [self notifyDelegateFetchedUserData];
    }

    
}

-(void)setPassword:(NSString *)password{
    BOOL prevStatus = [self isLoggedin];
    
    _password = password;
    
    if([self isLoggedin]){
        if(prevStatus) [self notifyDelegateLoggedOUT];
        [self notifyDelegateLoggedIN];
    }
    
}

- (NSString *)password{
    return _password;
}

-(UIImage*)image{
    return _image;
}

-(void)setImage:(UIImage*)image{
    _image = image;
    if(image){
        [self notifyDelegateFetchedUserImage];
    }
}

-(BOOL) isThereEnoughUserData{
    return (self.firstName && self.email);
}


@end
