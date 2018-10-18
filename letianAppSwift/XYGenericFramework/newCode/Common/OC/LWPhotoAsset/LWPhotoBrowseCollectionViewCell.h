//
//  LWPhotoBrowseCollectionViewCell.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWPhotoBrowseCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

/** 背景视图 */
@property (nonatomic,strong) UIScrollView * bgScrollView;
/** 图片 */
@property (nonatomic,strong) UIImageView * imageView;

@end
