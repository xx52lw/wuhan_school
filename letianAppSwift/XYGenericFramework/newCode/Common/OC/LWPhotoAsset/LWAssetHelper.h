//
//  LWAssetHelper.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWPHAsset.h"
// ==========================================================================================================================================================================================
#pragma mark 图片资源帮助类
@interface LWAssetHelper : NSObject

/** 获取bundle图片 */
+ (UIImage *)imageBundleWithName:(NSString *)imageName;
/** 获取原始图片 */
+ (UIImage *)originalImage:(LWPHAsset *)asset;
/** 获取缩略图片 */
+ (UIImage *)smallImageSize:(CGSize)size asset:(LWPHAsset *)asset;
/** 获取图片资源 */
+ (NSArray<LWPHAsset *> *)getSystemImageAssetArray;

@end
// ==========================================================================================================================================================================================
