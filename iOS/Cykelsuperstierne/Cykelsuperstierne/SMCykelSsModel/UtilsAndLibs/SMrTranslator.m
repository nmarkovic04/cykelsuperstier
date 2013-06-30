//
//  SMrTranslator.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 6/27/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMrTranslator.h"
#import <objc/runtime.h>
@interface SMrTranslator()
@property(nonatomic, strong) NSMutableDictionary * dict;
@property(nonatomic, strong, readwrite) NSNumber * translationVersion;

-(void) incrementVersion;

@end

@implementation SMrTranslator

- (id)init{
    self = [super init];
    if(self){
        [self baseInit];
    }
    return self;
}

-(id) initWithBundleStringFile:(NSString*)stringName{
    self = [super init];
    if(self){
        [self baseInit];
        [self setStringFile:stringName];
    }
    return self;
}

-(void) baseInit{
    self.translationVersion = [NSNumber numberWithUnsignedLong:0];
}

- (void)setStringFile:(NSString *)stringFile{
    [self incrementVersion];
    _stringFile = nil;
    _dict = nil;
    _stringFile = [[NSBundle mainBundle] pathForResource:stringFile ofType:@"strings"];
    if(!_stringFile) _stringFile = [[NSBundle mainBundle] pathForResource:stringFile ofType:nil];
    if(!_stringFile) return;
    
    _dict = [NSMutableDictionary dictionaryWithContentsOfFile:_stringFile];
}

+(NSString *)notificationName{
    return @"SMrTranslationChanged";
}

-(NSString*) translateString:(NSString*)keyText{
    NSString * ret = [self.dict valueForKey:keyText];
    if(ret) return ret;
    return keyText;
}

-(BOOL) translateView:(UIView*)view{
    if(!self.dict) return NO;
    return [view translateWith:self];
}

-(BOOL) setTranslation:(NSString*) translation forKeyword:(NSString*) keyword{
    if(!self.dict) return NO;
    [self.dict setValue:translation forKey:keyword];
    [self incrementVersion];
    return YES;
}

-(BOOL) removeTranslationForKeyword:(NSString*) keyword{
    if(!self.dict) return NO;
    [self.dict removeObjectForKey:keyword];
    [self incrementVersion];
    return YES;
}

-(void) incrementVersion{
    unsigned long val = [self.translationVersion unsignedLongValue];
    self.translationVersion = [NSNumber numberWithUnsignedLong:(++val)];

    [[NSNotificationCenter defaultCenter] postNotificationName:[SMrTranslator notificationName] object:self];
    
}



@end

#pragma mark - UIView(SMrTranslator)
@implementation UIView(SMrTranslator)

static char kTranslatorObj;
static char kTranslatorVersionObj;
static char kTranslationKeysObj;

- (NSDictionary *)translationKeys{
    return objc_getAssociatedObject(self, &kTranslationKeysObj);
}

- (void)setTranslationKeys:(NSDictionary *)translationKeys{
    objc_setAssociatedObject(self, &kTranslationKeysObj,
                             translationKeys,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber*)translationVersion{
    return objc_getAssociatedObject(self, &kTranslatorVersionObj);
}

- (void)setTranslationVersion:(NSNumber*)translationVersion{
    objc_setAssociatedObject(self, &kTranslatorVersionObj,
                             translationVersion,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SMrTranslator *)translator{
    return objc_getAssociatedObject(self, &kTranslatorObj);
}

- (void)setTranslator:(SMrTranslator *)translator{
    objc_setAssociatedObject(self, &kTranslatorObj,
                             translator,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) translateWith:(SMrTranslator*)translator{
    if(!translator) return NO;
    if(self.translator == translator  && self.translationVersion == translator.translationVersion) return NO;
    
    for(UIView * subview in self.subviews){
        [subview translateWith:translator];
    }
    
    self.translator = translator;
    self.translationVersion = translator.translationVersion;
    
    return YES;
}

@end

#pragma mark - UITextField(SMrTranslator)
@implementation UITextField(SMrTranslator)

-(BOOL) translateWith:(SMrTranslator*)translator{
    if(![super translateWith:translator]) return NO;
    
    NSDictionary * dict = self.translationKeys;
    NSString * textKey, * placeholderKey;
    
    if(dict){
        textKey = [dict valueForKey:@"text"];
        placeholderKey = [dict valueForKey:@"placeholder"];
    } else {
        self.translationKeys = [NSMutableDictionary new];
        textKey = self.text;
        if(textKey) [self.translationKeys setValue:textKey forKey:@"text"];
        placeholderKey = self.placeholder;
        if(placeholderKey) [self.translationKeys setValue:placeholderKey forKey:@"text"];
    }
    
    self.text = [translator translateString:textKey];
    self.placeholder = [translator translateString:placeholderKey];
    
    return YES;
}

@end

#pragma mark - UILabel(SMrTranslator)
@implementation UILabel(SMrTranslator)
-(BOOL) translateWith:(SMrTranslator*)translator{
    if(![super translateWith:translator]) return NO;
    
    NSDictionary * dict = self.translationKeys;
    NSString * textKey;
    
    if(dict){
        textKey = [dict valueForKey:@"text"];
    } else {
        self.translationKeys = [NSMutableDictionary new];
        textKey = self.text;
        if(textKey) self.translationKeys = @{@"text" : textKey};
    }
    
    self.text = [translator translateString:textKey];
    
    return YES;
}
@end

#pragma mark - UIButton(SMrTranslator)
@implementation UIButton(SMrTranslator)
-(BOOL) translateWith:(SMrTranslator*)translator{
    
    NSDictionary * dict = self.translationKeys;
    NSString    * textNormalKey,
                * textHighlightedKey,
                * textDisabledKey,
                * textSelectedKey;
    
    if(dict){
        textNormalKey = [dict valueForKey:@"Normal"];
        textHighlightedKey = [dict valueForKey:@"Highlighted"];
        textDisabledKey = [dict valueForKey:@"Disabled"];
        textSelectedKey = [dict valueForKey:@"Selected"];

    } else {
        textNormalKey = [self titleForState:UIControlStateNormal];
        textHighlightedKey = [self titleForState:UIControlStateHighlighted];
        textDisabledKey = [self titleForState:UIControlStateDisabled];
        textSelectedKey = [self titleForState:UIControlStateSelected];

        NSMutableDictionary * newDict = [NSMutableDictionary new];
        if(textNormalKey) [newDict setValue:textNormalKey forKey:@"Normal"];
        if(textHighlightedKey) [newDict setValue:textHighlightedKey forKey:@"Highlighted"];
        if(textDisabledKey) [newDict setValue:textDisabledKey forKey:@"Disabled"];
        if(textSelectedKey) [newDict setValue:textSelectedKey forKey:@"Selected"];
        
        self.translationKeys = newDict;
    }
    if(textNormalKey) [self setTitle:[translator translateString:textNormalKey] forState:UIControlStateNormal];
    if(textHighlightedKey) [self setTitle:[translator translateString:textHighlightedKey] forState:UIControlStateHighlighted];
    if(textDisabledKey) [self setTitle:[translator translateString:textDisabledKey] forState:UIControlStateDisabled];
    if(textSelectedKey)[self setTitle:[translator translateString:textSelectedKey] forState:UIControlStateSelected];
    
    return YES;
}
@end