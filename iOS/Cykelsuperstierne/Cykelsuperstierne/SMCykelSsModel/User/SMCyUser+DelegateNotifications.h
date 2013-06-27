//
//  SMCyUser+DelegateNotifications.h
//  Cykelsuperstierne
//
//  Created by Rasko on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyUser.h"

@interface SMCyUser (DelegateNotifications)

-(void)notifyDelegatesWillTryLogIN;
-(void)notifyDelegatesDidLogIN;
-(void)notifyDelegatesFailedToLogIN;
-(void)notifyDelegatesDidLogOUT;
-(void)notifyDelegatesDidDeleteAccount;
-(void)notifyDelegatesWillTryFetchUserData;
-(void)notifyDelegatesDidFetchUserData;
-(void)notifyDelegatesFailedFetchUserData;
-(void)notifyDelegatesDidFetchUserImage;

@end
