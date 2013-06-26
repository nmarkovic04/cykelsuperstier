//
//  SMCykelAccount.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyAccount.h"
#import "SMCyEmailAccount.h"
#import "SMCyFacebookAccount.h"

@implementation SMCyAccount

- (eAccountType)accountType{
    NSAssert(NO, @"accountType must be implemented in %@", self.class);
    return AT_UNKNOWN;
}

- (eAuthenticationType)authenticationType{
    NSAssert(NO, @"authenticationType must be implemented in %@", self.class);
    return AuT_UNKNOWN;
}

+(SMCyAccount*)createAccountOfType:(eAccountType)type WithDelegate:(id<SMCyAccountDelegate>) delegate{
    SMCyAccount * ret;
    switch (type) {
        case AT_EMAIL:
            ret = [SMCyEmailAccount new];
            break;
        case AT_FACEBOOK:
            ret = [SMCyFacebookAccount defaultAccount];
            break;
            
        default:
            break;
    }
    
    ret.delegate = delegate;
    
    return ret;
}

-(BOOL) isLoggedin{
    NSAssert(NO, @"isLoggedin must be implemented in %@", self.class);
    return NO;
}

-(void) login{
    NSAssert(NO, @"login must be implemented in %@", self.class);
}
-(void) logout{
    NSAssert(NO, @"logout must be implemented in %@", self.class);
}

-(BOOL) fetchUserData{
//    NSAssert(NO, @"fetchUserData must be implemented in %@", self.class);
    [self notifyDelegateFetchedUserDataFailed];
    return NO;
}

-(BOOL) fetchUserImage{
//    NSAssert(NO, @"fetchUserImage must be implemented in %@", self.class);
    [self notifyDelegateFetchedUserImageFailed];
    return NO;
}

-(BOOL) saveToCache:(NSString *)filePath{
    NSAssert(NO, @"saveToCache must be implemented in %@", self.class);
    return NO;
}

-(BOOL) loadFromCache:(NSString *)filePath{
    NSAssert(NO, @"loadFromCache must be implemented in %@", self.class);
    return NO;
}


-(BOOL) isUserDataLocked{
    NSAssert(NO, @"isUserDataLocked must be implemented in %@", self.class);
    return YES;
}

-(NSString*)alias{
    NSAssert(NO, @"alias must be implemented in %@", self.class);
    return nil;
}

-(void)setAlias:(NSString*)alias{
    NSAssert([self isUserDataLocked], @"You shouldn't call setAlias for locked data in %@", self.class);
    NSAssert(NO, @"if data is not locked you should implement setAlias in %@", self.class);
}

-(NSString*)firstName{
    NSAssert(NO, @"alias must be implemented in %@", self.class);
    return nil;
}

-(void)setFirstName:(NSString*)firstName{
    NSAssert([self isUserDataLocked], @"You shouldn't call setFirstName for locked data in %@", self.class);
    NSAssert(NO, @"if data is not locked you should implement setFirstName in %@", self.class);
}

-(NSString*)lastName{
    NSAssert(NO, @"alias must be implemented in subclass");
    return nil;
}

-(void)setLastName:(NSString*)lastName{
    NSAssert([self isUserDataLocked], @"You shouldn't call setLastName for locked data in %@", self.class);
    NSAssert(NO, @"if data is not locked you should implement setLastName in %@", self.class);
}

-(NSString*)email{
    NSAssert(NO, @"alias must be implemented in subclass");
    return nil;
}

-(void)setEmail:(NSString*)email{
    NSAssert([self isUserDataLocked], @"You shouldn't call setEmail for locked data in %@", self.class);
    NSAssert(NO, @"if data is not locked you should implement setEmail in %@", self.class);
}

-(UIImage*)image{
    NSAssert(NO, @"alias must be implemented in %@", self.class);
    return nil;
}

-(void)setImage:(UIImage*)image{
    NSAssert([self isUserDataLocked], @"You shouldn't call setImage for locked data in %@", self.class);
    NSAssert(NO, @"if data is not locked you should implement setImage in %@", self.class);
}

@end
