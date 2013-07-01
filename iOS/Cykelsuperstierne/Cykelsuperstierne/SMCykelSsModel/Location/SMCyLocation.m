//
//  SMCykelLocation.m
//  testAPIRequests
//
//  Created by Rasko on 6/22/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyLocation.h"
#import "SMrUtil.h"


@interface SMCyLocation(){
    CLLocationCoordinate2D _location2DCoord;
    CLLocation * _location;
}
@end

@implementation SMCyLocation

-(id)initWithDictionary:(NSDictionary*)data{
    self = [super init];
    
    if(self){
        [self setupWithDictionary:data];
    }
    
    return self;
}

-(void) setupWithDictionary:(NSDictionary*)data{  
    
    self.name = [data valueForKey:@"name"];
    self.city = [data valueForKey:@"city"];
    self.country = [data valueForKey:@"country"];
    self.street = [data valueForKey:@"street"];
    self.latitude = [data valueForKey:@"lat"];
    self.longitude = [data valueForKey:@"long"];
    self.source = [data valueForKey:@"source"];
    self.subsource = [data valueForKey:@"subsource"];
    self.order = [data valueForKey:@"order"];
    self.relevance = [data valueForKey:@"relevance"];
    self.icon_url = [data valueForKey:@"icon"];
    self.zip = [data valueForKey:@"zip"];
    
}

-(NSDictionary*)getDataDictionary{
    NSMutableDictionary * data = [NSMutableDictionary new];
    
    if(self.name) [data setValue:self.name forKey:@"name"];
    if(self.city) [data setValue:self.city forKey:@"city"];
    if(self.country) [data setValue:self.country forKey:@"country"];
    if(self.street) [data setValue:self.street forKey:@"street"];
    if(self.latitude) [data setValue:self.latitude forKey:@"lat"];
    if(self.longitude) [data setValue:self.longitude forKey:@"long"];
    if(self.source) [data setValue:self.source forKey:@"source"];
    if(self.subsource) [data setValue:self.subsource forKey:@"subsource"];
    if(self.order) [data setValue:self.order forKey:@"order"];
    if(self.relevance) [data setValue:self.relevance forKey:@"relevance"];
    if(self.icon_url) [data setValue:self.icon_url forKey:@"icon"];
    if(self.zip) [data setValue:self.zip forKey:@"zip"];

    return data;
}

#pragma mark - setters/getters

-(NSNumber *)latitude{
    return MK_DOUBLE(_location2DCoord.latitude);
}

-(void)setLatitude:(NSNumber *)latitude{
    _location = nil;
    _location2DCoord.latitude = GT_DOUBLE(latitude);
}
-(NSNumber *)longitude{
    return MK_DOUBLE(_location2DCoord.longitude);
}

-(void)setLongitude:(NSNumber *)longitude{
    _location = nil;
    _location2DCoord.longitude = GT_DOUBLE(longitude);
}


-(CLLocationCoordinate2D)location2DCoord{
    return _location2DCoord;
}

-(void)setLocation2DCoord:(CLLocationCoordinate2D)location2DCoord{
    _location2DCoord = location2DCoord;
    _location = [[CLLocation alloc] initWithLatitude:_location2DCoord.latitude longitude:_location2DCoord.longitude];
}


-(CLLocation *)location{
    if(!_location){
        _location = [[CLLocation alloc] initWithLatitude:_location2DCoord.latitude longitude:_location2DCoord.longitude];
    }
    return _location;
}

-(void)setLocation:(CLLocation *)location{
    _location2DCoord = location.coordinate;
    _location = location;
}

@end
