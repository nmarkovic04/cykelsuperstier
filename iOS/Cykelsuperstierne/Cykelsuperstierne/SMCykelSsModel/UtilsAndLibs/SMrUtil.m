//
//  SMrUtil.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/24/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrUtil.h"
#import "SMrError.h"

@implementation SMrUtil

#pragma mark - paths
+(NSString*) getDocumentsPath{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    return [dirPaths lastObject];
}

+(NSString*) getDocumentsPathForFile:(NSString*)fileName{
    return [SMrUtil getPathFromBasePath:[SMrUtil getDocumentsPath] subDirs:nil andFile:fileName];
}

+(NSString*) getDocumentsPathForSubDirs:(NSArray*)subDirs andFile:(NSString*)fileName{
    return [SMrUtil getPathFromBasePath:[SMrUtil getDocumentsPath] subDirs:subDirs andFile:fileName];
}


+(NSString*) getCachePath{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                            NSUserDomainMask, YES);
    return [dirPaths lastObject];
}

+(NSString*) getCachePathForFile:(NSString*)fileName{
    return [SMrUtil getPathFromBasePath:[SMrUtil getCachePath] subDirs:nil andFile:fileName];
}

+(NSString*) getCachePathForSubDirs:(NSArray*)subDirs andFile:(NSString*)fileName{
    return [SMrUtil getPathFromBasePath:[SMrUtil getCachePath] subDirs:subDirs andFile:fileName];
}

+(NSString*) getPathFromBasePath:(NSString*)basePath subDirs:(NSArray*)subDirs andFile:(NSString*)fileName{
    NSString * path = basePath;
    for(NSString * subDir in subDirs){
        path = [path stringByAppendingPathComponent:subDir];
    }
    return [path stringByAppendingPathComponent:fileName];
}




#pragma mark - delegate notification

+(void)notifyOnMainThreadDelegate:(id)delegate WithSelector:(SEL) sel AndObject:(NSObject*)obj{
    if(delegate && [delegate respondsToSelector:sel]){
        __weak __block NSObject * locObj = obj;
        __weak __block id locDelegate = delegate;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [locDelegate performSelector:sel withObject:locObj];
#pragma clang diagnostic pop
        }];
    }
}
+(void)notifyDelegate:(id)delegate WithSelector:(SEL) sel AndObject:(NSObject*)obj{
    if(delegate && [delegate respondsToSelector:sel]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [delegate performSelector:sel withObject:obj];
#pragma clang diagnostic pop
    }
}

+(void)notifyDelegatesList:(id)delegates WithSelector:(SEL) sel AndObject:(NSObject*)obj{
    for(id deleg in delegates){
        if(!deleg) continue;
        [SMrUtil notifyDelegate:deleg WithSelector:sel AndObject:obj];
    }
}

+(void)notifyOnMainThreadDelegatesList:(NSArray*)delegates WithSelector:(SEL)sel AndObject:(NSObject*)obj{
    for(id deleg in delegates){
        if(!deleg) continue;
        [SMrUtil notifyOnMainThreadDelegate:deleg WithSelector:sel AndObject:obj];
    }
}

#pragma mark - files

+(SMrError*)deleteFileOnPath:(NSString*)path{
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * err;
    [fm removeItemAtPath:path error:&err];
    if(err) return [[SMrError alloc] initWithNSError:err];
    else    return nil;
}

#pragma mark - device

@end
