//
//  NSArray+DDQArray.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;
@interface NSArray (DDQArray)

- (NSArray *)ddq_arrayAtIndex:(NSUInteger)index;
- (NSDictionary *)ddq_dictionaryAtIndex:(NSUInteger)index;
- (NSString *)ddq_stringAtIndex:(NSUInteger)index;
- (NSMutableArray *)ddq_mutableArrayAtIndex:(NSUInteger)index;
- (NSMutableDictionary *)ddq_mutableDictionaryAtIndex:(NSUInteger)index;
- (NSMutableString *)ddq_mutableStringAtIndex:(NSUInteger)index;

/**
 取出对应索引的值
 
 @param index 索引
 @return 如果越界，则返回为nil。
 */
- (nullable id)ddq_objectAtIndex:(NSUInteger)index;

/**
 找到索引对应的对象。并且转换成想要的数据类型。即使数组越界也不会返回空值。
 
 @param index 索引
 @param oClass 对象的类型
 @return 指定类型的对象。这个方法不会返回nil。
 */
- (id)ddq_objectAtIndex:(NSUInteger)index withClass:(Class)oClass;

/**
 将网络图片保存到本地
 */
- (void)ddq_storeUrlImagesToDisk;

/**
 取出保存的图片

 @return 图片集合。没有也是个空数组
 */
- (NSArray<UIImage *> *)ddq_urlImagesFormDisk;

/**
 利用谓词检索，过滤数组
 
 @param format 检索条件
 @return 过滤后的结果集。不为空，出现异常则为空数组
 */
- (NSArray *)ddq_filterObjectWithFormat:(NSString *)format;
- (NSArray *)ddq_filterObjectWithPredicate:(NSPredicate *)pre;

/**
 判断某个对象或者索引是不是最后一个元素
 
 @param object 对象
 @return Y/N
 */
- (BOOL)ddq_isLastObjectWithObject:(id)object;
- (BOOL)ddq_isLastObjectWithIndex:(NSUInteger)index;

@end

@interface NSMutableArray (DDQMutableArray)

/**
 插入一个对象，返回操作后的数组长度
 
 @param object 对象
 @param index 插入的位置
 @return 数组的长度。下面👇的几个方法含义一致。
 */
- (NSUInteger)ddq_insertObject:(nullable id)object atIndex:(NSUInteger)index;
- (NSUInteger)ddq_addObject:(nullable id)object;
- (NSUInteger)ddq_replaceObject:(nullable id)object atIndex:(NSUInteger)index;

/**
 利用谓词检索，过滤数组
 
 @param format 检索条件
 @return 过滤后的数组长度
 */
- (NSUInteger)ddq_filterObjectWithFormat:(NSString *)format;
- (NSUInteger)ddq_filterObjectWithPredicate:(NSPredicate *)pre;

@end

NS_ASSUME_NONNULL_END
