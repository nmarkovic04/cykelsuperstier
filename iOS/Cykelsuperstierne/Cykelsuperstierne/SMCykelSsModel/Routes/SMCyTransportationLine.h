//
//  SMCyTransportationLine.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCyTransportationLine : NSObject

@property(nonatomic, strong, readonly) NSArray * stations;
@property(nonatomic, strong, readonly) NSString * name;

-(id) initWithFile:(NSString*)filePath;
-(void) loadFromFile:(NSString*)filePath;
@end
