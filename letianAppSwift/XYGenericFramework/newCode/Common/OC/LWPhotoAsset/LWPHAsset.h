//
//  LWPHAsset.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LWPHAsset : NSObject

@property (nonatomic,strong) PHAsset * asset;
/** 标记 */
@property (nonatomic,assign) NSInteger  tag;
/** 是否选择 */
@property (nonatomic,assign) BOOL  isSelect;
/** 原始图片 */
@property (nonatomic,strong) UIImage * originalImage;

@end
