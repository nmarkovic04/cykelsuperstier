//
//  SMCyAccount+protected.h
//  testAPIRequests
//
//  Created by Rasko on 6/23/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyAccount.h"

@interface SMCyAccount (Protected)

-(void) notifyDelegateLoggedIN;
-(void) notifyDelegateFailedToLogIN;
-(void) notifyDelegateLoggedOUT;
-(void) notifyDelegateFailedToLogOUT;
-(void) notifyDelegateFetchedUserData;
-(void) notifyDelegateFetchedUserImage;
-(void) notifyDelegateFetchedUserDataFailed;
-(void) notifyDelegateFetchedUserImageFailed;
@end
