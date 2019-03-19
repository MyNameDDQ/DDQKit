//
//  NSDictionary+DDQDictionary.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSDictionary+DDQDictionary.h"

#import "NSObject+DDQObject.h"

@implementation NSDictionary (DDQDictionary)

- (id)ddq_objectWithClass:(Class)oClass forKey:(NSString *)key {
    
    if (![[self allKeys] containsObject:key]) {
        
        return [[oClass alloc] init];
        
    }
    
    id object = nil;
    @try {
        
        if ([self respondsToSelector:@selector(objectForKey:)]) {
            
            object = [self objectForKey:key];
            
        } else {
            
            object = [self valueForKey:key];
            
        }
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception);
        
    }
    return [self ddq_judgeObject:object withClass:oClass];
    
}

- (NSArray *)ddq_arrayForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSArray class] forKey:key];
    
}

- (NSDictionary *)ddq_dictionaryForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSDictionary class] forKey:key];
    
}

- (NSString *)ddq_stringForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSString class] forKey:key];
    
}

- (NSMutableArray *)ddq_mutableArrayForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSMutableArray class] forKey:key];
    
}

- (NSMutableString *)ddq_mutableStringForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSMutableString class] forKey:key];
    
}

- (NSMutableDictionary *)ddq_mutableDictionaryForKey:(NSString *)key {
    
    return [self ddq_objectWithClass:[NSMutableDictionary class] forKey:key];
    
}

@end

@implementation NSMutableDictionary (DDQMutableDictionary)

- (void)ddq_setObject:(id)object forKey:(NSString *)key {
    
    if (object) {
        
        [self setObject:object forKey:key];
        
    }
}

@end
