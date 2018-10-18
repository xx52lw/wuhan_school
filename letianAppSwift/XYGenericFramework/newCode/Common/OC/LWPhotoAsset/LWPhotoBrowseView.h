//
//  LWPhotoBrowseView.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAssetHelper.h"
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图
@interface LWPhotoBrowseView : UIView

/** 图片资源数组 */
@property (nonatomic,strong) NSMutableArray<LWPHAsset *> * assetArray;
/** 选择图片数组 */
@property (nonatomic,strong) NSMutableArray<LWPHAsset *> * selectedArray;
/** 当前展示的索引 */
@property (nonatomic,assign) NSInteger  showIndex;
/** 展示视图 */
- (void)showViewAtView:(UIView *)supView;
/** 最多选择的图片数量 */
@property (nonatomic,assign) NSInteger  maxSelectCount;
@property (nonatomic,strong) UIViewController * vc;
@property (nonatomic,copy) void(^block)(BOOL isChange);

@end
// ==========================================================================================================================================================================================
