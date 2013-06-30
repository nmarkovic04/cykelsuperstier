//
//  SMCySettings.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/26/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySettings.h"
#import "SMrUtil.h"
#import "SMrTranslator.h"
#import "SMrUtil.h"

@interface SMCySettings(){
    SMrTranslator * _translator;
}
@property(nonatomic, strong) NSNumber * daysReminder;
@property(nonatomic, strong) NSNumber * mapLayers;
@property(nonatomic, strong) NSString * fileName;
@property(nonatomic, strong, readwrite) NSNumber * showFirstTimeIntro;
@property(nonatomic, strong, readwrite) SMrTranslator * translator;
@end

@implementation SMCySettings

-(BOOL) loadFromFileNamed:(NSString*)fileName{
    if(fileName){
        self.fileName = fileName;
    } else if(!self.fileName){
        return NO;
    }
    
    NSString * path = [SMrUtil getCachePathForFile:self.fileName];
    
    NSDictionary * data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(!data) return NO;
    
    [self loadDefaults];
    
    for (NSString * key in data.allKeys) {
        if([self respondsToSelector:NSSelectorFromString(key)]){
            [self setValue:[data valueForKey:key] forKey:key];
        }
    }
    
    return YES;
}

-(BOOL) saveToFileNamed:(NSString*)fileName{

    if(fileName){
        self.fileName = fileName;
    } else if(!self.fileName){
        return NO;
    }
    
    NSString * path = [SMrUtil getCachePathForFile:self.fileName];
    
    NSMutableDictionary * data = [NSMutableDictionary new];
    [data setValue:self.daysReminder forKey:@"daysReminder"];
    [data setValue:self.mapLayers forKey:@"mapLayers"];
    [data setValue:self.localizationCode forKey:@"localizationCode"];

    return [NSKeyedArchiver archiveRootObject:data toFile:path];
    
}

-(void) loadDefaults{
    self.localizationCode = @"dk";
    self.daysReminder = MK_UCHAR(0);
    self.mapLayers = MK_UCHAR(0);
    self.showFirstTimeIntro = NO;
}

- (SMrTranslator *)translator{
    if(!_translator){
        _translator = [[SMrTranslator alloc] initWithBundleStringFile:_localizationCode];
    }
    return _translator;
}

-(BOOL) isReminderSetForDay:(eDays)day{
    return (GT_UCHAR(self.daysReminder) & day) != 0;
}

-(void) setReminder:(BOOL)on forDay:(eDays)day{
    unsigned char dr = GT_UCHAR(self.daysReminder);
    if(on){
        dr |= day;
    } else {
        dr &= ~day;
    }
    self.daysReminder = MK_UCHAR(dr);
}

-(BOOL) isMapLayerTurnedOn:(eMapLayers)mapLayer{
    return (GT_UCHAR(self.mapLayers) & mapLayer) != 0;
}
-(void) turnOn:(BOOL)on mapLAyer:(eMapLayers)mapLayer{
    unsigned char ml = GT_UCHAR(self.mapLayers);
    if(on){
        ml |= mapLayer;
    } else {
        ml &= ~mapLayer;
    }
    self.mapLayers = MK_UCHAR(ml);
}

-(BOOL) shouldShowFirstTimeIntro{
    return GT_BOOL(self.showFirstTimeIntro);
}


+(SMCySettings*)sharedInstance{
    static SMCySettings * sharedInstance = nil;
    
    if(!sharedInstance){
        sharedInstance = [SMCySettings new];
        if(![sharedInstance loadFromFileNamed:@"default.set"]){
            [sharedInstance loadDefaults];
            sharedInstance.showFirstTimeIntro = MK_BOOL(YES);
        }
    }
    
    return sharedInstance;
}


@end
