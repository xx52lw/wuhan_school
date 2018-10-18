//
//  LWAssetCollectionViewCell.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
// ==========================================================================================================================================================================================
#pragma mark 图片图片预览
@interface LWAssetCollectionViewCell : UICollectionViewCell

/** 添加按钮 */
@property (nonatomic,strong) UIButton * addBtn;
/** 图片 */
@property (nonatomic,strong) UIImageView * imageView;

@end
// ==========================================================================================================================================================================================
