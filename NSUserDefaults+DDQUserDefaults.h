//
//  NSUserDefaults+DDQUserDefaults.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/22.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *DDQUserDefaultChangeKey;
typedef void(^DDQUserDefaultValuesChangedBlock)(NSDictionary <DDQUserDefaultChangeKey, id> *changes);

NS_AVAILABLE_IOS(1_0_1)
@interface NSUserDefaults (DDQUserDefaults)

/**
 监听userDefault中某个字段的变化

 @param key 字段
 @param changed 变化后的回调
 */
+ (void)ddq_userDefaultObserverWithKey:(NSString *)key changed:(DDQUserDefaultValuesChangedBlock)changed;

@end

FOUNDATION_EXTERN DDQUserDefaultChangeKey const DDQUserDefaultOldValueKey;
FOUNDATION_EXTERN DDQUserDefaultChangeKey const DDQUserDefaultNewValueKey;

NS_ASSUME_NONNULL_END
