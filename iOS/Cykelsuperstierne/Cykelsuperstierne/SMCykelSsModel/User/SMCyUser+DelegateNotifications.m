//
//  SMCyUser+DelegateNotifications.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyUser+DelegateNotifications.h"
#import "SMrUtil.h"

@implementation SMCyUser (DelegateNotifications)
#pragma mark - delegate notification utils

-(void)notifyDelegatesWillTryLogIN{
    [self notifyDelegatesWithSelector:@selector(userWillTryLogIN:)];
}
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
-(void)notifyDelegatesWillTryFetchUserData{
    [self notifyDelegatesWithSelector:@selector(userWillTryFetchUserData:)];
}
-(void)notifyDelegatesDidFetchUserData{
    [self notifyDelegatesWithSelector:@selector(userDidFetchUserData:)];
}
-(void)notifyDelegatesDidFetchUserImage{
    [self notifyDelegatesWithSelector:@selector(userDidFetchUserImage:)];
}
-(void)notifyDelegatesFailedFetchUserData{
    [self notifyDelegatesWithSelector:@selector(userFailedFetchUserData:)];
}
-(void) notifyDelegatesWithSelector:(SEL)sel{
    [SMrUtil notifyOnMainThreadDelegatesList:self.delegates WithSelector:sel AndObject:self];
}

@end
