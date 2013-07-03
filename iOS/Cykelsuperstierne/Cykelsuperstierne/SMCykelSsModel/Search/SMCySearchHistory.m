//
//  SMCySearchHistory.m
//  Cykelsuperstierne
//
//  Created by Nikola Markovic on 7/3/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCySearchHistory.h"
#import "SMCySearchHistoryEntity.h"
#import "SMrUtil.h"

// search keys
#define sKeyTime @"sKeyTime"
#define sKeyLocation @"location"
#define sKeyEntity @"sKeyEntity"

#define MAX_ENTITIES 6
#define searchHistoryFileName @"searchHistory.plist"

@implementation SMCySearchHistory{
    NSMutableArray* entities;
    NSComparisonResult(^comparator)(SMCySearchHistoryEntity* e1, SMCySearchHistoryEntity* e2);
}

+(SMCySearchHistory*)instance{
    static SMCySearchHistory* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance= [[SMCySearchHistory alloc] init];
        [instance load];
    });
    return instance;
}

-(id)init{
    if(self= [super init]){
        comparator=  ^NSComparisonResult(SMCySearchHistoryEntity* e1, SMCySearchHistoryEntity* e2){
            NSDate * d1 = e1.timeOfSearch;
            NSDate * d2 = e2.timeOfSearch;
            return [d2 compare:d1];
        };
    }
    return self;
}

-(BOOL)load{
    entities= [NSMutableArray new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: searchHistoryFileName]]) {
        NSMutableArray * arr = [NSArray arrayWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: searchHistoryFileName]];
        
        if (arr) {
            for (NSDictionary * d in arr) {
                NSDictionary* entityDict= [d objectForKey:sKeyEntity];
                NSDate* time= [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[d objectForKey:sKeyTime]).doubleValue ];
                SMCyLocation* location= [[SMCyLocation alloc] initWithDictionary:entityDict];
                SMCySearchHistoryEntity* entity= [[SMCySearchHistoryEntity alloc] initWithLocation:location time:time];
                [entities addObject:entity];
            }
            [entities sortUsingComparator:comparator];
            
            [self removeExcessEntities];
            return YES;
        }else{
            return NO;
        }
    }
    
    return NO;
}

-(BOOL)save{
    NSMutableArray * arr = [NSMutableArray new];
    int count= 0;
    for (SMCySearchHistoryEntity * entity in entities) {
        if(count==MAX_ENTITIES)
            break;
        
        [arr addObject:@{
         sKeyEntity : [entity.location getDataDictionary],
           sKeyTime : MK_DOUBLE(entity.timeOfSearch.timeIntervalSince1970)
         }];
        
        count++;
    }
    
    return [arr writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: searchHistoryFileName] atomically:YES];
}

-(void)addSearchEntity:(SMCySearchHistoryEntity*)entity{
    if([self shouldAddEntity:entity model:self.entities]){
        [entities insertObject:entity atIndex:0];
        [self removeExcessEntities];
        [self save];
    }
}

-(void)removeExcessEntities{
    while (entities.count>MAX_ENTITIES) {
        [entities removeLastObject];
    }
}

-(BOOL)shouldAddEntity:(SMCySearchHistoryEntity*)entity model:(NSArray*)pEntities{
    int duplicates= [pEntities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.location.longitude == %lf AND SELF.location.latitude == %lf", entity.location.location2DCoord.longitude, entity.location.location2DCoord.latitude]].count;
    
    return duplicates==0;
}

-(void)addSearchEntityWithLocation:(SMCyLocation*)location{
    SMCySearchHistoryEntity* entity= [[SMCySearchHistoryEntity alloc] initWithLocation:location];
    [self addSearchEntity:entity];
}

-(NSArray*)entities{
    return entities;
}
@end
