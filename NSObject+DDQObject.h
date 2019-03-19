//
//  NSObject+DDQObject.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DDQObject)

/**
 判断一个对象是不是我指定的类型

 @param object 目标对象
 @param oClass 指定类型
 @return 如果目标对象是指定类型，则返回object，否则初始化一个默认的指定类型。不会返回nil
 */
- (id)ddq_judgeObject:(id)object withClass:(Class)oClass;

@end

NS_ASSUME_NONNULL_END
