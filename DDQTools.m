//
//  DDQTools.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/24.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "DDQTools.h"

#import <AFNetworking/AFNetworking.h>
#import <SAMKeychain/SAMKeychain.h>
#import "NSString+DDQString.h"
#import "NSDictionary+DDQDictionary.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0" //移动网络
#define IOS_WIFI        @"en0"     //wifi
#define IOS_VPN         @"utun0"   //vpn
#define IOS_LOCATION     @"lo0"     //本地ip

#define IP_ADDR_IPv4    @"ipv4"    //ipv4
#define IP_ADDR_IPv6    @"ipv6"    //ipv6

@implementation DDQTools

+ (NSString *)ddq_getPhoneIpWithType:(DDQPhoneIpType)type {
    
    NSString *key = @"";
    switch (type) {
        case DDQPhoneIpTypeWifi_ipv4:
            key = [IOS_WIFI stringByAppendingFormat:@"/%@", IP_ADDR_IPv4];
            break;
        case DDQPhoneIpTypeWifi_ipv6:
            key = [IOS_WIFI stringByAppendingFormat:@"/%@", IP_ADDR_IPv6];
            break;
        case DDQPhoneIpTypeCellular_ipv4:
            key = [IOS_CELLULAR stringByAppendingFormat:@"/%@", IP_ADDR_IPv4];
            break;
        case DDQPhoneIpTypeCellular_ipv6:
            key = [IOS_CELLULAR stringByAppendingFormat:@"/%@", IP_ADDR_IPv6];
            break;
        case DDQPhoneIpTypeLocal_ipv4:
            key = [IOS_LOCATION stringByAppendingFormat:@"/%@", IP_ADDR_IPv4];
            break;
        case DDQPhoneIpTypeLocal_ipv6:
            key = [IOS_LOCATION stringByAppendingFormat:@"/%@", IP_ADDR_IPv6];
            break;
        case DDQPhoneIpTypeVPN:
            key = [IOS_VPN stringByAppendingFormat:@"/%@", IP_ADDR_IPv6];
            break;
        default:
            break;
    }
    
    NSDictionary *addresses = [self ddq_getIpAddressInfo];
    NSString *address = [addresses ddq_stringForKey:key];
    return address;

}

+ (NSDictionary *)ddq_getIpAddressInfo {
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
    
}

static NSString *const KeyChainServiceName = @"DDQKit";
static NSString *const KeyChainAccountName = @"DDQUUID";

+ (NSString *)ddq_getDeviceId {
    
    NSString *UUID = [SAMKeychain passwordForService:KeyChainServiceName account:KeyChainAccountName];
    if (UUID.length == 0) {
        
        UUID = UIDevice.currentDevice.identifierForVendor.UUIDString;
        UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        UUID = [UUID lowercaseString];
        [SAMKeychain setPassword:UUID forService:KeyChainServiceName account:KeyChainAccountName];
    
    }
    [SAMKeychain deletePasswordForService:KeyChainServiceName account:KeyChainAccountName];

    return UUID;
    
}

static AFNetworkReachabilityManager *manager = nil;
+ (void)ddq_observerNetWorkConnection:(DDQToolsNetWorkChanged)work {
    
    if (manager) {
        
        [manager stopMonitoring];
        manager = nil;
        
    }
    
    manager = [AFNetworkReachabilityManager manager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (work) {
            
            work((status == AFNetworkReachabilityStatusReachableViaWiFi) ? YES : NO);
            
        }
    }];
    [manager startMonitoring];
    
}

+ (void)ddq_observerNetWorkConnectionSignleDesign:(DDQToolsNetWorkChanged)work {
    
    AFNetworkReachabilityManager *reachbilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (work) {
            
            work((status == AFNetworkReachabilityStatusReachableViaWiFi) ? YES : NO);
            
        }
    }];
    [reachbilityManager startMonitoring];
    
}

@end
