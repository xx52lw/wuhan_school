//
//  JCPCommonTools.h
//  Loter
//
//  Created by liwei on 2017/10/10.
//  Copyright © 2017年 JCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// ==================================================================================================================================
#pragma mark - 公共工具类
@interface OCCommonTools : NSObject

/** 处理图片大小 image 处理图片 scale 默认的压缩比 maxM最大M  */
+ (NSData *)imageOrange:(UIImage *)image defaultScale:(CGFloat)scale maxM:(CGFloat)maxM;


@end
// ==================================================================================================================================
