//
//  LWPhotoAssetBottomView.m
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWPhotoAssetBottomView.h"
// ==========================================================================================================================================================================================
#pragma mark 图片预览底部视图
@implementation LWPhotoAssetBottomView

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = [UIColor lightGrayColor];
        _topView.alpha = 0.5f;
    }
    return _topView;
}

#pragma mark 懒加载完成按钮
- (UIButton *)completeBtn {
    if (_completeBtn == nil) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBtn.backgroundColor = [UIColor clearColor];
        [_completeBtn setTitle:@"确定0/0" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _completeBtn.backgroundColor = [UIColor colorWithRed:250.0/255 green:120.0/255 blue:57.0/255 alpha:1.0];
        [_completeBtn sizeToFit];
    }
    return _completeBtn;
}
#pragma mark 懒加载取消按钮
- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

#pragma mark 重写init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.completeBtn];
        [self addSubview:self.cancelBtn];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.completeBtn];
        [self addSubview:self.cancelBtn];
    }
    return self;
}
#pragma mark 重写layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat w = self.frame.size.width;
    CGFloat h = 1.0f;
    self.topView.frame = CGRectMake(x, y, w, h);
    w = self.completeBtn.frame.size.width + 8.0f;
    h = self.completeBtn.frame.size.height;
    x = self.frame.size.width - w - 15.0f;
    y = 5.0f;
    self.completeBtn.frame = CGRectMake(x, y, w, h);
    self.completeBtn.layer.cornerRadius = 3.0f;
    self.completeBtn.layer.masksToBounds = YES;
    x = 10.0f;
    self.cancelBtn.frame = CGRectMake(x, y, w, h);
}

@end
// ==========================================================================================================================================================================================
