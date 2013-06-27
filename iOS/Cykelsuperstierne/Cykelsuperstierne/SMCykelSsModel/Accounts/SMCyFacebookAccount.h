//
//  SMCykelFacebookAccount.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

// NOTE: don't forget to add to AppDelegate:
// - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [FBSession.activeSession handleOpenURL:url];
//}
//
// - add FacebookAppID string to xxx-info.plist ... (XXXXXXXX)
// - add URL types/URL Schemes/ to xxx-info.plist ... fbXXXXXXXX 

#import <Foundation/Foundation.h>
#import "SMCyAccount+Protected.h"

@interface SMCyFacebookAccount : SMCyAccount
+(SMCyFacebookAccount*)defaultAccount;
@end
