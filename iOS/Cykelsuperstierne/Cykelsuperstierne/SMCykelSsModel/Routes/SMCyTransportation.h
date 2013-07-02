//
//  SMCyTransportation.h
//  Cykelsuperstierne
//
//  Created by Rasko on 7/2/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCyTransportation : NSObject
@property(nonatomic, strong, readonly) NSArray * lines;

-(void) loadDummyData;

+(SMCyTransportation*)sharedInstance;
@end
