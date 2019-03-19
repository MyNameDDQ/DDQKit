//
//  DDQModel.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "DDQModel.h"

#import <MJExtension/MJExtension.h>

@implementation DDQModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues {
    
    id object = [super mj_objectWithKeyValues:keyValues];
    if ([object respondsToSelector:@selector(model_handlePropertyList)]) {
        
        [object performSelector:@selector(model_handlePropertyList)];
        
    }
    return object;
    
}

- (NSMutableDictionary *)ddq_modelKeyValues {
    
    NSMutableDictionary *keyValues = [self mj_keyValues];
    NSArray *ignoredArr = @[@"description", @"debugDescription", @"hash", @"superclass"];
    [keyValues removeObjectsForKeys:ignoredArr];
    return keyValues;
    
}

/**
 读取模型类中的所有属性名称
 
 @return 属性名数组
 */
- (NSDictionary *)model_loadClassPropertyList {
    
    unsigned int listCount = 0;
    
    objc_property_t *propertys = class_copyPropertyList([self class], &listCount);
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:listCount];
    
    NSArray *ignoredArr = nil;
    if ([self respondsToSelector:@selector(model_ignoredPropertyNames)]) {
        ignoredArr = [self performSelector:@selector(model_ignoredPropertyNames)];
    }
    
    for (int index = 0; index < listCount; index++) {
        
        objc_property_t property = propertys[index];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        if ([ignoredArr containsObject:propertyName] && ignoredArr) {
            continue;
        }
        
        NSDictionary *propertyAttr = [self model_handlePropertyAttribute:[[NSString alloc] initWithUTF8String:property_getAttributes(property)]];
        [propertyDic setValue:propertyAttr forKey:propertyName];
        
    }
    free(propertys);
    
    return propertyDic.copy;
}

static NSString *const PropertyClass = @"PropertyClassName";
static NSString *const PropertyAttribute = @"PropertyAttributeName";
/**
 获取属性的修饰词，及属性的类型
 
 @param attr 属性的描述
 @return 一个字典
 */
- (NSDictionary *)model_handlePropertyAttribute:(NSString *)attr {
    
    NSArray *attrArr = [attr componentsSeparatedByString:@","];
    NSString *classStr = attrArr.firstObject;
    
    @try {
        
        //写的不够优雅 - - ！
        if ([[classStr substringToIndex:2] isEqualToString:@"T@"]) {//OC子类表现形式:T@"XXXXX"
            
            NSString *class = [classStr substringWithRange:NSMakeRange(3, classStr.length - 3 - 1)];
            return @{PropertyClass:class, PropertyAttribute:attrArr[1]};
            
        } else {//基础数据类型:TX
            
            return @{PropertyClass:[classStr substringWithRange:NSMakeRange(1, classStr.length - 1)]};
            
        }
    } @catch (NSException *exception) {
        
        
    }
}

- (void)model_handlePropertyList {
    
    //已被转化的key
    NSMutableDictionary *valueDic = [self ddq_modelKeyValues];
    NSArray *allKeyArr = [valueDic allKeys];
    
    //全部的key
    NSDictionary *propertyListDic = [self model_loadClassPropertyList];
    for (NSString *key in propertyListDic.allKeys) {//检查所有属性中被转化过的属性
        
        if ([allKeyArr containsObject:key]) {//找到已经被转化过的属性
            
            @try {
                
                id objecValue = [self valueForKey:key];
                NSDictionary *propertyAttr = propertyListDic[key];
                Class attrClass = NSClassFromString([propertyAttr objectForKey:PropertyClass]);
                if ([attrClass isSubclassOfClass:[NSString class]]) {//属性是不是NSString及其子类
                    
                    if (![[objecValue class] isSubclassOfClass:[NSString class]]) {//赋值的属性不是字符串及其子类
                        
                        [self setValue:[objecValue description] forKey:key];
                        
                    }
                }
                
                if ([[objecValue class] isSubclassOfClass:[NSNull class]] && [attrClass isSubclassOfClass:[NSObject class]]) {//赋值的是NSNull，且属性指向NSObject及其子类
                    
                    [self setValue:[[attrClass alloc] init] forKey:key];
                    
                }
            } @catch (NSException *exception) {
                
                NSLog(@"%@", exception);
                
            } @finally {
                
                continue;
                
            }
        }
    }
    
    //属性替换
    NSDictionary *replaceDic = nil;
    if ([self respondsToSelector:@selector(model_replacePropertyNames)]) {
        
        replaceDic = [self performSelector:@selector(model_replacePropertyNames)];
        //转化字典里所有的value即是被mj真正转化的服务器返回的属性名
        for (NSString *replaceKey in replaceDic.allKeys) {
            
            NSString *assignKey = [replaceDic valueForKey:replaceKey];
            if ([allKeyArr containsObject:assignKey]) {
                
                id object = [valueDic objectForKey:assignKey];
                [valueDic removeObjectForKey:assignKey];
                [valueDic setObject:object forKey:replaceKey];
                
            }
        }
        allKeyArr = valueDic.allKeys;
        
    }
    
    //未被转化的key
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", allKeyArr];
    NSArray *remainedArr = [propertyListDic.allKeys filteredArrayUsingPredicate:resultPre];
    
    //设置默认值
    for (NSString *remainedKey in remainedArr) {
        
        NSDictionary *attrDic = propertyListDic[remainedKey];
        Class propertyClass = NSClassFromString(attrDic[PropertyClass]);
        
        if ([propertyClass isSubclassOfClass:[NSObject class]]) {//OC子类
            
            @try {
                
                [self setValue:[[propertyClass alloc] init] forKey:remainedKey];
                
            } @catch (NSException *exception) {
                
                NSLog(@"%@", exception);
                
            } @finally {
                
                continue;
                
            }
        } else {//基础数据类型
        }
    }
}


@end
