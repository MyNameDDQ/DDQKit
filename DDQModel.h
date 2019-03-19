//
//  DDQModel.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDQModelHandler <NSObject>

@optional
/**
 处理模型类的属性列表,防止接口出现参数缺少或参数为null而导致取值时为空，进而导致的程序崩溃。
 */
- (void)model_handlePropertyList;

/**
 被忽视的属性名称
 */
- (NSArray *)model_ignoredPropertyNames;

/**
 被替换的属性名称
 */
- (NSDictionary *)model_replacePropertyNames;


@end

@interface DDQModel : NSObject<DDQModelHandler>

/**
 获得定义的所有属性值
 
 @return 属性名和值形成的字典
 */
- (NSMutableDictionary *)ddq_modelKeyValues;

@end

NS_ASSUME_NONNULL_END
