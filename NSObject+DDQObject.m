//
//  NSObject+DDQObject.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSObject+DDQObject.h"

#import <objc/runtime.h>

@implementation NSObject (DDQObject)

- (id)ddq_judgeObject:(id)object withClass:(Class)oClass {
        
    if (!object) {
        
        return [[oClass alloc] init];
        
    }
    
    if ([[object class] isSubclassOfClass:[NSNull class]]) {//防止返回值有NSNull的情况
        
        return [[oClass alloc] init];
        
    }
    
    //对象不是指定类的子类
    if (![[object class] isSubclassOfClass:oClass]) {
        
        /**
         反向检查，指定类是不是对象的子类。
         例如：我object是一个NSArray的对象，但是oClass被指定为NSMutableArray。
         这个时候，对象不是指定类的子类，但是指定类是对象的子类
         */
        if ([oClass isSubclassOfClass:[object superclass]]) {//实际操作中往往不是得到正确的类型。但绝大多数情况下都是往下继承一层。
            
            Protocol *mutablePro = objc_getProtocol("NSMutableCopying");
            if ([object conformsToProtocol:mutablePro]) {
                
                return [object mutableCopy];
                
            } else {
                
                return [[oClass alloc] init];
                
            }
        } else {
            
            //写这个为了防范__NSCFNumber的出现
            if ([oClass isSubclassOfClass:[NSString class]]) {
                
                return [object description];
                
            }
            return [[oClass alloc] init];
            
        }
    }
    return object;
    
}


@end
