//
//  SMrTranslator.h
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

//Translator//////////////////////////////////////////////////////////
@interface SMrTranslator : NSObject
@property(nonatomic, strong) NSString * stringFile;
@property(nonatomic, strong, readonly) NSNumber * translationVersion;

-(id) initWithBundleStringFile:(NSString*)stringName;

-(NSString*) translateString:(NSString*)keyText;
-(BOOL) translateView:(UIView*)view;

-(BOOL) setTranslation:(NSString*) translation forKeyword:(NSString*) keyword;
-(BOOL) removeTranslationForKeyword:(NSString*) keyword;

+(NSString*) notificationName;
@end
//////////////////////////////////////////////////////////////////////



//View translation
@interface UIView(SMrTranslator)
@property(nonatomic, readonly) NSNumber * translationVersion;
@property(nonatomic, strong, readonly) SMrTranslator * translator;
@property(nonatomic, strong, readonly) NSDictionary * translationKeys;
-(BOOL) translateWith:(SMrTranslator*)translator;
@end

//UITextField translation
@interface UITextField(SMrTranslator)
-(BOOL) translateWith:(SMrTranslator*)translator;
@end

//UILabel translation
@interface UILabel(SMrTranslator)
-(BOOL) translateWith:(SMrTranslator*)translator;
@end

//UIButton translation
@interface UIButton(SMrTranslator)
-(BOOL) translateWith:(SMrTranslator*)translator;
@end