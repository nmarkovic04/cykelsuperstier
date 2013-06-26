//
//  SMCySettings.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySettings.h"

@implementation SMCySettings

-(BOOL) loadFromFileNamed:(NSString*)fileName{
    //TODO: implement
    return NO;
}

-(BOOL) saveFromFileNamed:(NSString*)fileName{
    //TODO: implement
    return NO;
}


+(SMCySettings*)sharedInstance{
    static SMCySettings * sharedInstance = nil;
    
    if(!sharedInstance){
        sharedInstance = [SMCySettings new];
    }
    
    return sharedInstance;
}


@end
