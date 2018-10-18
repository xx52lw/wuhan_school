//
//  LWPhotoAssetBottomView.h
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
// ==========================================================================================================================================================================================
#pragma mark 图片预览底部视图
@interface LWPhotoAssetBottomView : UIView

/** 头部分割线 */
@property (nonatomic,strong) UIView * topView;
/** 完成按钮 */
@property (nonatomic,strong) UIButton * completeBtn;
/** 取消按钮 */
@property (nonatomic,strong) UIButton * cancelBtn;

@end
// ==========================================================================================================================================================================================

