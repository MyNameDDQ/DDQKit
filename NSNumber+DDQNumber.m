//
//  NSNumber+DDQNumber.m
//  DDQKit
//
//  Created by 我叫咚咚枪 on 2019/3/19.
//  Copyright © 2019 我叫咚咚枪. All rights reserved.
//

#import "NSNumber+DDQNumber.h"

#import <DDQUIKit/UIView+DDQLayoutGuide.h>

@implementation NSNumber (DDQNumber)

- (CGFloat)scaleValue {
    
    DDQScreenScale scale = [UIView ddq_getScreenScaleWithType:DDQScreenVersionType6];
#if defined(__LP64__) && __LP64__
    
    return self.doubleValue * scale.widthScale;
    
#else
    
    return self.floatValue * scale.widthScale;
    
#endif
    
}

@end
