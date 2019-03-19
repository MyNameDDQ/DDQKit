//
//  UIImage+DDQImage.h
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DDQImage)

/**
 将图片压缩到指定大小

 @param size 单位为：kb
 @return 新图片
 */
- (nullable UIImage *)ddq_scaleToTargetSize:(NSInteger)size;

/**
 将图片压缩到指定尺寸

 @param frame 目标尺寸
 @return 新图片
 */
- (nullable UIImage *)ddq_scaleToTargetFrame:(CGRect)frame;

/**
 将图片压缩至固定宽度，高度自适应

 @param width 目标宽度
 @return 新图片
 */
- (nullable UIImage *)ddq_scaleToTargetWidth:(CGFloat)width;

/**
 将图片压缩至微信规定的大小内。不超过32K

 @return 新图片
 */
- (nullable UIImage *)ddq_scaleToWeChatShareSize;

@end

NS_ASSUME_NONNULL_END
