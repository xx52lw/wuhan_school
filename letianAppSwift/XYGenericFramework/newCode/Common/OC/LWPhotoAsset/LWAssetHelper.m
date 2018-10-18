//
//  LWAssetHelper.m
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWAssetHelper.h"

@implementation LWAssetHelper

#pragma mark 获取bundle图片
+ (UIImage *)imageBundleWithName:(NSString *)imageName {
    
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"LWPhotoAssetImage.bundle" ofType:nil] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark 获取原始图片
+ (UIImage *)originalImage:(LWPHAsset *)asset {
    
    __block UIImage *resultImage;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset.asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeDefault
                                                  options:phImageRequestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                resultImage = result;
//                                                NSLog(@"%@",result);
                                            }];
    
    return resultImage;
}
#pragma mark 获取缩略图片
+ (UIImage *)smallImageSize:(CGSize)size asset:(LWPHAsset *)asset {
    __block UIImage *resultImage;
    //初始化控制图片请求操作的一些属性
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    //PHImageRequestOptionsResizeModeExact 则返回图像必须和目标大小相匹配，并且图像质量也为高质量图像
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageRequestOptions.synchronous = YES;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(size.width * scale,size.height * scale);
    //通过获取的图片资源信息  请求得到image信息
    [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage  = result;
    }];
    return resultImage;
}
#pragma mark 获取图片资源
+ (NSArray<LWPHAsset *> *)getSystemImageAssetArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //获取资源时的参数，可以传 nil，即使用系统默认值
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //获取资源   fetchAssetsWithMediaType：所获取的资源类型 PHAssetMediaTypeImage（获取所有图片资源）
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    if ([fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
        //遍历所有资源  并将资源每个图片资源信息存入数组
        for (NSInteger i = 0; i < fetchResult.count; ++i) {
            PHAsset *asset = [fetchResult objectAtIndex:i];
            LWPHAsset *lwasset = [[LWPHAsset alloc] init];
            lwasset.asset = asset;
            lwasset.isSelect = NO;
            lwasset.tag = i;
            [array addObject:lwasset];
        }
    }
    return array;
}

@end
