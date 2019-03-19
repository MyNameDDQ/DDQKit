//
//  NSDictionary+DDQDictionary.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (DDQDictionary)

/**
 以某个键名，找到对应元素。哪怕allKey中没有键名，也将返回一个非空对象。下👇同
 
 @param key 键名
 @param oClass 对象类型
 @return 一个非空对象
 */
- (id)ddq_objectWithClass:(Class)oClass forKey:(NSString *)key;

- (NSArray *)ddq_arrayForKey:(NSString *)key;
- (NSDictionary *)ddq_dictionaryForKey:(NSString *)key;
- (NSString *)ddq_stringForKey:(NSString *)key;
- (NSMutableArray *)ddq_mutableArrayForKey:(NSString *)key;
- (NSMutableDictionary *)ddq_mutableDictionaryForKey:(NSString *)key;
- (NSMutableString *)ddq_mutableStringForKey:(NSString *)key;

@end

@interface NSMutableDictionary (DDQMutableDictionary)

/**
 往数组里添加数据的同时防范，对象为空而导致的崩溃。
 
 @param object 一个对象
 @param key 键名
 */
- (void)ddq_setObject:(nullable id)object forKey:(NSString *)key;

@end


NS_ASSUME_NONNULL_END
