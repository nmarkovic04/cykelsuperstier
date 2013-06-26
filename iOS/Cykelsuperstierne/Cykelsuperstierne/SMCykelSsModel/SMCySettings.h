//
//  SMCySettings.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCySettings : NSObject

-(BOOL) loadFromFileNamed:(NSString*)fileName;
-(BOOL) saveFromFileNamed:(NSString*)fileName;

+(SMCySettings*)sharedInstance;

@end
