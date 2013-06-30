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

+(id)createInstanceFromClassName:(NSString*)className;

@end

//macros for POD to NSNumber conversion and vice versa

#define MK_FLOAT(_num_) [NSNumber numberWithFloat:(_num_)]
#define GT_FLOAT(_num_) [(_num_) floatValue]

#define MK_DOUBLE(_num_) [NSNumber numberWithDouble:(_num_)]
#define GT_DOUBLE(_num_) [(_num_) doubleValue]

#define MK_BOOL(_num_) [NSNumber numberWithBool:(_num_)]
#define GT_BOOL(_num_) [(_num_) boolValue]

#define MK_CHAR(_num_) [NSNumber numberWithChar:(_num_)]
#define GT_CHAR(_num_) [(_num_) charValue]

#define MK_UCHAR(_num_) [NSNumber numberWithUnsignedChar:(_num_)]
#define GT_UCHAR(_num_) [(_num_) unsignedCharValue]

#define MK_SHORT(_num_) [NSNumber numberWithShort:(_num_)]
#define GT_SHORT(_num_) [(_num_) shortValue]

#define MK_USHORT(_num_) [NSNumber numberWithUnsignedShort:(_num_)]
#define GT_USHORT(_num_) [(_num_) unsignedShortValue]

#define MK_INT(_num_) [NSNumber numberWithInt:(_num_)]
#define GT_INT(_num_) [(_num_) intValue]

#define MK_UINT(_num_) [NSNumber numberWithUnsignedInt:(_num_)]
#define GT_UINT(_num_) [(_num_) unsignedIntValue]

#define MK_LONG(_num_) [NSNumber numberWithLong:(_num_)]
#define GT_LONG(_num_) [(_num_) longValue]

#define MK_ULONG(_num_) [NSNumber numberWithUnsignedLong:(_num_)]
#define GT_ULONG(_num_) [(_num_) unsignedLongValue]

#define MK_LONGLONG(_num_) [NSNumber numberWithLongLong:(_num_)]
#define GT_LONGLONG(_num_) [(_num_) longLongValue]

#define MK_ULONGLONG(_num_) [NSNumber numberWithUnsignedLongLong:(_num_)]
#define GT_ULONGLOMG(_num_) [(_num_) unsignedLongLongValue]
