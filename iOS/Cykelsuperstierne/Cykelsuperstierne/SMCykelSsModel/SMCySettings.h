//
//  SMCySettings.h
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  SMrTranslator;

typedef enum _eDays{
    MONDAY      = 1 << 0,
    TUESDAY     = 1 << 1,
    WEDNESDAY   = 1 << 2,
    THURSDAY    = 1 << 3,
    FRIDAY      = 1 << 4
} eDays;

typedef enum _eMapLayers{
    ML_GREENROUTE      = 1 << 0,
    ML_SERVICESTATIONS = 1 << 1,
    ML_TRAINSTATIONS   = 1 << 2,
    ML_METROSTATIONS   = 1 << 3,
} eMapLayers;

@interface SMCySettings : NSObject

@property(nonatomic, strong) NSString * localizationCode;
@property(nonatomic, strong, readonly) SMrTranslator * translator;

-(BOOL) loadFromFileNamed:(NSString*)fileName;
-(BOOL) saveToFileNamed:(NSString*)fileName;

-(BOOL) isReminderSetForDay:(eDays)day;
-(void) setReminder:(BOOL)on forDay:(eDays)day;

-(BOOL) isMapLayerTurnedOn:(eMapLayers)mapLayer;
-(void) turnOn:(BOOL)on mapLAyer:(eMapLayers)mapLayer;

-(BOOL) shouldShowFirstTimeIntro;


+(SMCySettings*)sharedInstance;

@end
