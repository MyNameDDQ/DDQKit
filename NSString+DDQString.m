//
//  NSString+DDQString.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSString+DDQString.h"

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

@implementation NSString (DDQString)

- (NSString *)ddq_getUrlValueForKey:(NSString *)key {
    
    if (!key || key.length == 0) {
        return @"";
    }
    
    return [[self ddq_getUrlVaulesForKeys:@[key]] objectForKey:key] ? : @"";
    
}

- (NSDictionary<NSString *,NSString *> *)ddq_getUrlVaulesForKeys:(NSArray<NSString *> *)keys {
    
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    NSURL *url = [NSURL URLWithString:self];
    if (url) {
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        if (components) {
            
            for (NSURLQueryItem *item in components.queryItems) {
                
                if ([keys containsObject:item.name]) {
                    
                    [dic setObject:item.value.length == 0 ? @"" : item.value forKey:item.name];
                    
                }
            }
        }
        
        if (dic.count == 0) {
            
            //下面的判断适用于不是规范的url请求规则时。
            //http://img.bjtitile.com/newshow/newsid/1 类似这种的
            if ([self containsString:@"/"]) {
                
                NSArray *values = [self componentsSeparatedByString:@"/"];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", values];
                NSArray *filteredArr = [keys filteredArrayUsingPredicate:predicate];
                if (filteredArr.count > 0) {
                    
                    for (NSString *value in filteredArr) {
                        
                        NSUInteger index = [values indexOfObject:value];
                        
                        if (index + 1 <= values.count - 1) {
                            
                            NSString *string = values[index + 1];
                            [dic setObject:string forKey:value];
                            
                        }
                    }
                }
            }
        }
    }
    return dic.copy;
    
}

- (NSString *)ddq_handleTimeStamp:(NSString *)ts formatter:(NSString *)formatter {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts.doubleValue];
    if (formatter.length == 0) {
        
        formatter = @"yyyy-MM-dd HH:mm";
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
    
}

+ (NSString *)ddq_getAppVersion {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
}

- (NSString *)ddq_appendUrlQueryWithKeyValues:(NSDictionary<NSString *,NSString *> *)values {
    
    if (!self || self.length == 0) {
        return @"";
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:self];
    if (!components) {
        return self;
    }
    
    if (values.count == 0) {
        return self;
    }
    
    if (components.queryItems.count == 0) {
        
        NSMutableArray<NSURLQueryItem *> *items = [NSMutableArray array];
        [values.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:obj value:values[obj]];
            [items addObject:item];
            
        }];
        components.queryItems = items.copy;
        
    } else {
        
        NSMutableArray<NSURLQueryItem *> *items = [NSMutableArray array];
        NSMutableArray<NSString *> *exitsNames = [NSMutableArray array];
        [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [exitsNames addObject:obj.name];
            
        }];
        
        NSPredicate *notInPre = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", exitsNames];
        NSArray<NSString *> *notExistNames = [values.allKeys filteredArrayUsingPredicate:notInPre];
        [notExistNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:obj value:values[obj]];
            [items addObject:item];
            
        }];
        components.queryItems = items.copy;
        
    }
    return components.URL.absoluteString ? : @"";
    
}

- (NSAttributedString *)ddq_handleHTMLToAttributeString {
    
    if (!self || self.length == 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributedString.copy;
    
}

+ (NSString *)ddq_getCurrentTimeStamp {
    
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    
}

- (NSString *)ddq_stringByTrimmingBlank {
    
    if (!self) {
        
        return @"";
        
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (void)ddq_storeUrlImageToDisk {
    
    if (!self || self.length == 0) {
        return;
    }
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    UIImage *image = [cache imageFromDiskCacheForKey:self];
    if (!image) {
        
        image = [cache imageFromCacheForKey:self];
        if (!image) {
            
            image = [cache imageFromMemoryCacheForKey:self];
            if (!image) {
                
                [downloader downloadImageWithURL:[NSURL URLWithString:self] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                    if (finished && !error) {
                        
                        [cache storeImage:image forKey:self toDisk:YES completion:nil];
                        
                    }
                }];
            }
        }
    }
}

- (UIImage *)ddq_urlImageFormDisk {
    
    if (!self || self.length == 0) {
        return nil;
    }

    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromDiskCacheForKey:self];
    if (!image) {
        
        image = [cache imageFromCacheForKey:self];
        if (!image) {
            
            image = [cache imageFromMemoryCacheForKey:self];
            
        }
    }
    return image;
    
}

- (BOOL)ddq_isNumberOfType:(DDQStringNumberType)type {
    
    if (!self || self.length == 0) {
        return NO;
    }
    
    BOOL isNumber = NO;
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    switch (type) {
            
        case DDQStringNumberTypeInt:{
            
            int i = 0;
            isNumber = [scanner scanInt:&i];
            
        }break;
            
        case DDQStringNumberTypeInteger:{
            
            NSInteger i = 0;
            isNumber = [scanner scanInteger:&i];
            
        }break;
            
        case DDQStringNumberTypeFloat:{
            
            float f = 0.0;
            isNumber = [scanner scanFloat:&f];
            
        }break;

        case DDQStringNumberTypeDouble:{
            
            double d = 0.0;
            isNumber = [scanner scanDouble:&d];
            
        }break;
            
        case DDQStringNumberTypeLongLong:{
            
            long long ll = 0;
            isNumber = [scanner scanLongLong:&ll];
            
        }break;
            
        case DDQStringNumberTypeUnsignedLongLong:{
            
            unsigned long long ull = 0;
            isNumber = [scanner scanUnsignedLongLong:&ull];
            
        }break;

        case DDQStringNumberTypeHexInt:{
            
            unsigned int ui = 0;
            isNumber = [scanner scanHexInt:&ui];
            
        }break;

        case DDQStringNumberTypeHexFloat:{
            
            float uf = 0.0;
            isNumber = [scanner scanHexFloat:&uf];
            
        }break;

        case DDQStringNumberTypeHexDouble:{
            
            double ud = 0.0;
            isNumber = [scanner scanHexDouble:&ud];
            
        }break;
            
        case DDQStringNumberTypeHexLongLong:{
            
            unsigned long long ull = 0;
            isNumber = [scanner scanHexLongLong:&ull];
            
        }break;

        default:
            break;
    }
    return isNumber && [scanner isAtEnd];

}

- (BOOL)ddq_isEmail {
    
    return [self ddq_validateUsePredicateWithRegexString:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];

}

- (BOOL)ddq_isPersonalId {
    
    if (self.length == 15 || self.length == 18) {
        return NO;
    }
    
    NSString *regex = (self.length == 15) ? @"^(\\d{6})([3-9][0-9][01][0-9][0-3])(\\d{4})$" : @"^(\\d{6})([12][90][3-9][0-9][01][0-9][0-3])(\\d{4})(\\d|[xX])$";
    return [self ddq_validateUsePredicateWithRegexString:regex];

}

- (BOOL)ddq_isPhone {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];

}

- (BOOL)ddq_containIllegalCharacter {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^[A-Za-z0-9\\u4e00-\u9fa5]+$"];
    
}

- (BOOL)ddq_isCarId {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^[A-Za-z]{1}[A-Za-z_0-9]{5}$"];
    
}

- (BOOL)ddq_isChinese {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^[\u4e00-\u9fa5]+$"];

}

- (BOOL)ddq_isIp {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    
}

- (BOOL)ddq_isPostalCode {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^[0-8]\\d{5}(?!\\d)$"];
    
}

- (BOOL)ddq_isWebUrl {
    
    return [self ddq_validateUsePredicateWithRegexString:@"^((http)|(https))+:[^\\s]+\\.[^\\s]*$"];
}

- (BOOL)ddq_validateWithRegexString:(NSString *)regex {
    
    return [self ddq_validateUsePredicateWithRegexString:regex];
    
}

- (BOOL)ddq_validateWithNewAppVersion:(NSString *)version {
    
    if (version.length == 0)
        return NO;
    
    if (self.length == 0)
        return NO;
    
    __block BOOL needUpdate = NO;
    @try {
        
        NSArray<NSString *> *currentInfos = [self componentsSeparatedByString:@"."];
        NSArray<NSString *> *newInfos = [version componentsSeparatedByString:@"."];
        [newInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *info = [currentInfos objectAtIndex:idx];
            if (obj.integerValue > info.integerValue) {//新的版本号，有任意一位大于本地版本号即可提示更新
                
                needUpdate = YES;
                *stop = YES;
                
            }
        }];
    } @catch (NSException *exception) {
        
        //到这里了一般是格式不正确
        needUpdate = NO;
        
    } @finally {
        
        return needUpdate;
        
    }
}

/**
 利用正则判断是否符合特定要求

 @param regex 正则表达式
 @return Y/N
 */
- (BOOL)ddq_validateUsePredicateWithRegexString:(NSString *)regex {

    if (!self || self.length == 0) {
        return NO;
    }

    if (regex.length == 0 || !regex) {
        return NO;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pre evaluateWithObject:self];
    
}


@end
