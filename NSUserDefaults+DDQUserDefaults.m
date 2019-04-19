//
//  NSUserDefaults+DDQUserDefaults.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/22.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSUserDefaults+DDQUserDefaults.h"

#import "NSDictionary+DDQDictionary.h"

@implementation NSUserDefaults (DDQUserDefaults)

DDQUserDefaultChangeKey const DDQUserDefaultOldValueKey = @"DDQOldValueKey";
DDQUserDefaultChangeKey const DDQUserDefaultNewValueKey = @"DDQNewValueKey";

static id observer = nil;
+ (void)ddq_userDefaultObserverWithKey:(NSString *)key changed:(DDQUserDefaultValuesChangedBlock)changed {
    
    if (key.length == 0) {
        return;
    }
    
    NSUserDefaults *defaults = [self standardUserDefaults];
    __block id oldValues = [defaults objectForKey:key];
    
    if (observer) {
        return;
    }
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (changed) {
            
            NSUserDefaults *defaults = note.object;
            id newValues = [defaults objectForKey:key];
            
            if (newValues == oldValues) return;
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [dic ddq_setObject:oldValues forKey:DDQUserDefaultOldValueKey];
            [dic ddq_setObject:newValues forKey:DDQUserDefaultNewValueKey];
            oldValues = newValues;
            
            changed(dic);
            
        }
        [self ddq_removeUserDefaultObserver];
        
    }];
}

+ (void)ddq_removeUserDefaultObserver {
    
    if (observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        
    }
}

@end
