//
//  SMCyRoute+Protected.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRoute.h"

@interface SMCyRoute (Protected)
- (void)setState:(eRouteState)state;
- (void)setError:(SMrError*)error;
@end
