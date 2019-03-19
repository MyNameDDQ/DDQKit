//
//  UIImage+DDQImage.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "UIImage+DDQImage.h"

#import <YYKit/YYKit.h>

@implementation UIImage (DDQImage)

- (UIImage *)ddq_scaleToTargetSize:(NSInteger)size {
    
    if (!self) {
        return nil;
    }
    
    NSInteger bSize = size * 1024;
    
    CGFloat startQuality = 0.9;
    CGFloat minQuality = 0.1;
    NSData *imageData = [YYImageEncoder encodeImage:self type:YYImageTypeJPEG quality:startQuality];
    while ([imageData length] > bSize || startQuality > minQuality) {
        
        startQuality -= 0.1;
        imageData = [YYImageEncoder encodeImage:self type:YYImageTypeJPEG quality:startQuality];
        
    }
    
    if (imageData.length > bSize) {
        
        return [self ddq_scaleToTargetWidth:100.0];
        
    } else {
        
        return [UIImage imageWithData:imageData];
        
    }
}

- (UIImage *)ddq_scaleToTargetFrame:(CGRect)frame {
    
    if (!self) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:frame];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

- (UIImage *)ddq_scaleToTargetWidth:(CGFloat)width {
    
    CGSize imageSize = self.size;
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    //压缩后的高度和压缩前保持等比
    CGFloat targetHeight = (width / imageW) * imageH;
    return [self ddq_scaleToTargetFrame:CGRectMake(0.0, 0.0, imageW, targetHeight)];
    
}

- (UIImage *)ddq_scaleToWeChatShareSize {
    
    return [self ddq_scaleToTargetSize:31];
    
}

@end
