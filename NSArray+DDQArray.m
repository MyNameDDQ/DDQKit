//
//  NSArray+DDQArray.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSArray+DDQArray.h"

#import "NSObject+DDQObject.h"
#import "NSString+DDQString.h"

@implementation NSArray (DDQArray)

- (id)ddq_objectAtIndex:(NSUInteger)index {
    
    return [self ddq_arrayBeyondWithIndex:index] ? nil : [self objectAtIndex:index];
    
}

- (id)ddq_objectAtIndex:(NSUInteger)index withClass:(Class)oClass {
    
    id object = [self ddq_objectAtIndex:index];
    return [self ddq_judgeObject:object withClass:oClass];
    
}

- (void)ddq_storeUrlImagesToDisk {
    
    if (self.count == 0) {
        return;
    }
    
    for (id object in self) {
        
        if ([object isKindOfClass:[NSString class]] && [object respondsToSelector:@selector(ddq_storeUrlImageToDisk)]) {
            
            [object performSelector:@selector(ddq_storeUrlImageToDisk)];
            
        }
    }
}

- (NSArray<UIImage *> *)ddq_urlImagesFormDisk {
    
    if (self.count == 0) {
        
        return @[];
        
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        
        if ([object isKindOfClass:[NSString class]] && [object respondsToSelector:@selector(ddq_urlImageFormDisk)]) {
            
            UIImage *image = [object performSelector:@selector(ddq_urlImageFormDisk)];
            [array addObject:image];
            
        }
    }
    return array.copy;
    
}

- (NSArray *)ddq_filterObjectWithFormat:(NSString *)format {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:format];
    return [self ddq_filterObjectWithPredicate:pre];
    
}

- (NSArray *)ddq_filterObjectWithPredicate:(NSPredicate *)pre {
    
    if (!pre) {
        return @[];
    }
    
    NSArray *array = nil;
    @try {
        
        array = [self filteredArrayUsingPredicate:pre];
        
    } @catch (NSException *exception) {
        
        array = @[];
        
    } @finally {
        
        return array;
        
    }
}

- (NSArray *)ddq_arrayAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSArray class]];
    
}

- (NSDictionary *)ddq_dictionaryAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSDictionary class]];
    
}

- (NSString *)ddq_stringAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSString class]];
    
}

- (NSMutableArray *)ddq_mutableArrayAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSMutableArray class]];
    
}

- (NSMutableString *)ddq_mutableStringAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSMutableString class]];
    
}

- (NSMutableDictionary *)ddq_mutableDictionaryAtIndex:(NSUInteger)index {
    
    return [self ddq_objectAtIndex:index withClass:[NSMutableDictionary class]];
    
}

- (BOOL)ddq_isLastObjectWithObject:(id)object {
    
    if (self.lastObject == object) {
        
        return YES;
        
    }
    return NO;
    
}

- (BOOL)ddq_isLastObjectWithIndex:(NSUInteger)index {
    
    if (index == self.count - 1) {
        
        return YES;
        
    }
    return NO;
    
}

- (BOOL)ddq_arrayBeyondWithIndex:(NSUInteger)index {
    
    if (index > self.count - 1) {
        
        return YES;
        
    }
    return NO;
    
}

@end

@implementation NSMutableArray (DDQMutableArrayƒ)

- (NSUInteger)ddq_addObject:(id)object {
    
    if (object) {
        
        [self addObject:object];
        
    }
    return self.count;
    
}

- (NSUInteger)ddq_insertObject:(id)object atIndex:(NSUInteger)index {
    
    if (object && ![self ddq_arrayBeyondWithIndex:index]) {
        
        [self insertObject:object atIndex:index];
        
    }
    return self.count;
    
}

- (NSUInteger)ddq_replaceObject:(id)object atIndex:(NSUInteger)index {
    
    if (object && ![self ddq_arrayBeyondWithIndex:index]) {
        
        [self replaceObjectAtIndex:index withObject:object];
        
    }
    return self.count;
    
}

- (NSUInteger)ddq_filterObjectWithFormat:(NSString *)format {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:format];
    return [self ddq_filterObjectWithPredicate:pre];
    
}

- (NSUInteger)ddq_filterObjectWithPredicate:(NSPredicate *)pre {
    
    if (!pre) {
        return self.count;
    }

    NSUInteger length = 0;
    @try {
        
        [self filteredArrayUsingPredicate:pre];
        length = self.count;
        
    } @catch (NSException *exception) {
        
        length = self.count;
        
    } @finally {
        
        return length;
        
    }
}

@end

