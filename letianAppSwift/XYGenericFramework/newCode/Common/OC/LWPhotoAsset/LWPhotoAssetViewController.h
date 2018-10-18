//
//  LWPhotoAssetViewController.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAssetHelper.h"
@class LWPhotoAssetViewController;
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器代理方法
@protocol LWPhotoAssetViewControllerDelegate <NSObject>

@optional
/** 点击完成按钮 */
- (void)photoAssetViewController:(LWPhotoAssetViewController *)vc completeArray:(NSArray<LWPHAsset *> *) selectedArray;
/** 点击取消按钮 */
- (void)photoAssetViewControllerCancel:(LWPhotoAssetViewController *)vc;

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器
@interface LWPhotoAssetViewController : UIViewController
/** 代理属性 */
@property (nonatomic,weak)id<LWPhotoAssetViewControllerDelegate> delegate;
/** 最多选择的图片数量 */
@property (nonatomic,assign) NSInteger  maxSelectCount;
/** 一行最多显示个数(默认4个) */
@property (nonatomic,assign) NSInteger  lineMaxCount;

/** 选择图片数组 */
@property (nonatomic,strong) NSMutableArray<LWPHAsset *> * selectedArray;

/** 展示视图 */
- (void)showViewWithVC:(UIViewController *)vc;

@end
// ==========================================================================================================================================================================================
