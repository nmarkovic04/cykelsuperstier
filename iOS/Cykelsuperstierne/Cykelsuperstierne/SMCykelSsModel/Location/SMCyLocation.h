//
//  SMCykelLocation.h
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SMCyLocation : NSObject
@property(nonatomic,strong) NSString * street;
@property(nonatomic,strong) NSString * city;
@property(nonatomic,strong) NSString * country;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * source;
@property(nonatomic,strong) NSString * subsource;
@property(nonatomic,strong) NSString * icon_url;
@property(nonatomic,strong) NSString * zip;
@property(nonatomic,strong) NSNumber * order;
@property(nonatomic,strong) NSNumber * relevance;

@property(nonatomic,strong) NSNumber * latitude;
@property(nonatomic,strong) NSNumber * longitude;
@property(nonatomic,strong) CLLocation * location;
@property(nonatomic,assign) CLLocationCoordinate2D location2DCoord;


-(id)initWithDictionary:(NSDictionary*)data;

-(void) setupWithDictionary:(NSDictionary*)data;
-(NSDictionary*)getDataDictionary;

@end
