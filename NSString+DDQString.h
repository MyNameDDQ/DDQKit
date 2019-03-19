//
//  NSString+DDQString.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DDQStringNumberType) {
    
    DDQStringNumberTypeInt,
    DDQStringNumberTypeInteger,
    DDQStringNumberTypeLongLong,
    DDQStringNumberTypeUnsignedLongLong,
    DDQStringNumberTypeFloat,
    DDQStringNumberTypeDouble,
    DDQStringNumberTypeHexInt,
    DDQStringNumberTypeHexFloat,
    DDQStringNumberTypeHexDouble,
    DDQStringNumberTypeHexLongLong,

};

@class UIImage;
@interface NSString (DDQString)

/**
 从url字符串中，获得某个你想要的值
 
 @param key 键名
 @return 键值。没有找到对应的值，返回值也会是空串@""
 */
- (NSString *)ddq_getUrlValueForKey:(NSString *)key;

/**
 获得url中多个参数
 
 @param keys 键名数组
 @return 会以keys中的键为key，url的值为value
 */
- (NSDictionary<NSString *, NSString *> *)ddq_getUrlVaulesForKeys:(NSArray<NSString *> *)keys;

/**
 转化时间戳
 
 @param ts 时间戳
 @param formatter 默认格式：yyyy-MM-dd HH:mm
 @return 对应的时间戳表示
 */
- (NSString *)ddq_handleTimeStamp:(nullable NSString *)ts formatter:(nullable NSString *)formatter;

/**
 去除首尾空格
 
 @return 去除后的字符串。入本身为空，则返回空串
 */
- (NSString *)ddq_stringByTrimmingBlank;

/**
 拼接请求参数

 @param values 参数字典
 @return 新字符串
 */
- (NSString *)ddq_appendUrlQueryWithKeyValues:(nullable NSDictionary<NSString *, NSString *> *)values;

/**
 若自身是HTML字符串则转化成属性的字符串

 @return 属性字符串
 */
- (nullable NSAttributedString *)ddq_handleHTMLToAttributeString;

/**
 将url相关的图片存到本地
 */
- (void)ddq_storeUrlImageToDisk;

/**
 读取保存在本地的图片

 @return 图片
 */
- (nullable UIImage *)ddq_urlImageFormDisk;

/**
 获得当前版本号
 
 @return 版本号的字符串
 */
+ (NSString *)ddq_getAppVersion;

/**
 获得当前时间戳

 @return 时间戳字符串
 */
+ (NSString *)ddq_getCurrentTimeStamp;

/**
 判断字符是什么类型的数字

 @param type 数字类型
 @return Y/N
 */
- (BOOL)ddq_isNumberOfType:(DDQStringNumberType)type;

/**
 是不是邮箱

 @return Y/N
 */
- (BOOL)ddq_isEmail;

/**
 是不是身份证号码

 @return Y/N
 */
- (BOOL)ddq_isPersonalId;

/**
 是不是手机号

 @return Y/N
 */
- (BOOL)ddq_isPhone;

/**
 是否包含非法字符

 @return Y/N
 */
- (BOOL)ddq_containIllegalCharacter;

/**
 是不是车牌

 @return Y/N
 */
- (BOOL)ddq_isCarId;

/**
 是不是纯中文

 @return Y/N
 */
- (BOOL)ddq_isChinese;

/**
 是不是ip地址

 @return Y/N
 */
- (BOOL)ddq_isIp;

/**
 是不是邮编

 @return Y/N
 */
- (BOOL)ddq_isPostalCode;

/**
 是不是网址。只支持http,https

 @return Y/N
 */
- (BOOL)ddq_isWebUrl;

/**
 利用正则对本字符串进行判断

 @param regex 正则
 @return Y/N
 */
- (BOOL)ddq_validateWithRegexString:(NSString *)regex;

/**
 判断当前版本号
 
 @param version 返回的版本号
 @return YES则需要提示更新，NO则不需要提示更新
 */
- (BOOL)ddq_validateWithNewAppVersion:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
