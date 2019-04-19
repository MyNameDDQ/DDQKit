//
//  DDQKitDefineHeader.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/20.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#ifndef DDQKitDefineHeader_h
#define DDQKitDefineHeader_h

#define DDQDeviceWidth [UIScreen mainScreen].bounds.size.width
#define DDQDeviceHeight [UIScreen mainScreen].bounds.size.height
#define DDQFindNib(class) [UINib nibWithNibName:NSStringFromClass(class) bundle:[NSBundle mainBundle]]

#define DDQ_REQUIRES_SUPER __attribute__((objc_requires_super))
#if __has_attribute(objc_designated_initializer)
#define DDQ_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#endif

#define DDQWeakObject(objc)  __weak typeof(objc) weakObjc = objc
#define DDQStrongObject(objc)  __strong typeof(objc) strongObjc = objc
#define DDQ_iOS_Version [UIDevice currentDevice].systemVersion.floatValue
#define DDQ_iOS_VersionLater(version) DDQ_iOS_Version >= version ? YES : NO

#ifdef DEBUG
#define DDQFilePath [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DDQLog(...) NSLog(@"%@", [NSString stringWithFormat:@"file:%@ line:%d \n %@", DDQFilePath, __LINE__, [NSString stringWithFormat:__VA_ARGS__]]);
#else
#define DDQLog(...)
#endif

#endif /* DDQKitDefineHeader_h */
