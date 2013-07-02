//
//  SMCyTurnInstruction.m
//  Cykelsuperstierne
//
//  Created by Rasko on 7/2/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyTurnInstruction.h"

@implementation SMCyTurnInstruction

-(id) initWithArray:(NSArray*)data{
    self = [super init];
    if(self){
        [self setDataFromArray:data];
    }
    return self;
}

-(void) setDataFromArray:(NSArray*)data{
#warning unfinished method
    /*
     far as I can see, data looks something like this : ["7","Strandgade",126,3,39,"126m","SW",225,1]
     first is direction - probably,
     second is name, third is distance ... etc 
     TODO: check format and set data
     */
}

@end
