//
//  DDQTools.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/24.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DDQToolsNetWorkChanged)(BOOL isWIFI);

typedef NS_ENUM(NSUInteger, DDQPhoneIpType) {
    
    DDQPhoneIpTypeWifi_ipv4,         //ipv4下的wifi，Ip
    DDQPhoneIpTypeWifi_ipv6,         //ipv6下的wifi，Ip
    DDQPhoneIpTypeCellular_ipv4,     //ipv4下的移动网络，Ip
    DDQPhoneIpTypeCellular_ipv6,     //ipv6下的移动网络，Ip
    DDQPhoneIpTypeLocal_ipv4,        //ipv4下的本地，Ip
    DDQPhoneIpTypeLocal_ipv6,        //ipv6下的本地，Ip
    DDQPhoneIpTypeVPN,
    
};

NS_AVAILABLE_IOS(1_0_1)
@interface DDQTools : NSObject

/**
 获取手机ip
 */
+ (NSString *)ddq_getPhoneIpWithType:(DDQPhoneIpType)type;

/**
 获得手机ip相关的信息
 */
+ (NSDictionary *)ddq_getIpAddressInfo;

/**
 获得设备id
 */
+ (NSString *)ddq_getDeviceId;

/**
 观察当前网络环境

 @param work 网络环境发生改变
 */
+ (void)ddq_observerNetWorkConnection:(DDQToolsNetWorkChanged)work;

/**
 Reachbility的单例模式，全局观察当前网络环境

 @param work 网络环境的回调
 */
+ (void)ddq_observerNetWorkConnectionSignleDesign:(DDQToolsNetWorkChanged)work;


@end

NS_ASSUME_NONNULL_END
