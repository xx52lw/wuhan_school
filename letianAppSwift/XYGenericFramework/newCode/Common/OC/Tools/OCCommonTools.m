//
//  JCPCommonTools.m
//  Loter
//
//  Created by liwei on 2017/10/10.
//  Copyright © 2017年 JCP. All rights reserved.
//

#import "OCCommonTools.h"

@implementation OCCommonTools


#pragma mark 处理图片大小 image 处理图片 maxM最大M
+ (NSData *)imageOrange:(UIImage *)image defaultScale:(CGFloat)scale maxM:(CGFloat)maxM {
    if (image == nil || maxM <= 0) {
        return [NSData data];
    }
    if (scale <= 0 || scale > 1) {
        scale = 1.0f;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, scale);
    NSInteger M1 = 1024 * 1024; // 1M
    if (imageData.length > M1 * maxM) { // 大于兆
        CGFloat scale = (M1 * maxM * 1.0) / UIImageJPEGRepresentation(image, 1.0).length ;// 获取合适压缩
        imageData = UIImageJPEGRepresentation(image, scale);
    }
    return imageData;
}

@end
