//
//  SMCyAccount+protected.m
//  testAPIRequests
//
//  Created by Rasko on 6/23/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyAccount+Protected.h"
#import "SMrUtil.h"

@implementation SMCyAccount (Protected)

-(void) notifyDelegateLoggedIN{
    [self notifyDelegateWithSelector:@selector(accountDidLogIN:)];
}

-(void) notifyDelegateFailedToLogIN{
    [self notifyDelegateWithSelector:@selector(accountFailedToLogIN:)];
}

-(void) notifyDelegateLoggedOUT{
    [self notifyDelegateWithSelector:@selector(accountDidLogOUT:)];
}
-(void) notifyDelegateFailedToLogOUT{
    [self notifyDelegateFailedToLogOUT];
}

-(void) notifyDelegateFetchedUserData{
    [self notifyDelegateWithSelector:@selector(accountDidFetchUserData:)];
}

-(void) notifyDelegateFetchedUserImage{
    [self notifyDelegateWithSelector:@selector(accountDidFetchUserImage:)];
}

-(void) notifyDelegateFetchedUserDataFailed{
    [self notifyDelegateWithSelector:@selector(accountFetchUserDataFailed:)];
}
-(void) notifyDelegateFetchedUserImageFailed{
    [self notifyDelegateWithSelector:@selector(accountFetchUserImageFailed:)];
}


-(void)notifyDelegateWithSelector:(SEL) sel{
    
    [SMrUtil notifyDelegate:self.delegate WithSelector:sel AndObject:self];
//    
//    if(self.delegate && [self.delegate respondsToSelector:sel]){
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [self.delegate performSelector:sel withObject:self];
//#pragma clang diagnostic pop
//    }
}
@end
