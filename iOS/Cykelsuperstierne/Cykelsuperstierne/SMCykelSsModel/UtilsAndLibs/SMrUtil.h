//
//  SMrUtil.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  SMrError;

@interface SMrUtil : NSObject

#pragma mark - paths
+(NSString*) getDocumentsPath;
+(NSString*) getDocumentsPathForFile:(NSString*)fileName;
+(NSString*) getDocumentsPathForSubDirs:(NSArray*)subDirs andFile:(NSString*)fileName;
+(NSString*) getCachePath;
+(NSString*) getCachePathForFile:(NSString*)fileName;
+(NSString*) getCachePathForSubDirs:(NSArray*)subDirs andFile:(NSString*)fileName;
+(NSString*) getPathFromBasePath:(NSString*)basePath subDirs:(NSArray*)subDirs andFile:(NSString*)fileName;

+(void)notifyDelegate:(id)delegate WithSelector:(SEL) sel AndObject:(NSObject*)obj;
+(void)notifyOnMainThreadDelegate:(id)delegate WithSelector:(SEL) sel AndObject:(NSObject*)obj;
+(void)notifyDelegatesList:(NSArray*)delegates WithSelector:(SEL) sel AndObject:(NSObject*)obj;
+(void)notifyOnMainThreadDelegatesList:(NSArray*)delegates WithSelector:(SEL) sel AndObject:(NSObject*)obj;

+(SMrError*)deleteFileOnPath:(NSString*)path;

@end
