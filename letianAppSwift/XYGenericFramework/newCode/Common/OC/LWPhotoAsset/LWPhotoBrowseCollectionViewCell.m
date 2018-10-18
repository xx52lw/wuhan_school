//
//  LWPhotoBrowseCollectionViewCell.m
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWPhotoBrowseCollectionViewCell.h"

@implementation LWPhotoBrowseCollectionViewCell

#pragma mark 懒加载图片
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
#pragma mark 懒加载背景视图
- (UIScrollView *)bgScrollView {
    if (_bgScrollView == nil) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.delegate = self;
        _bgScrollView.minimumZoomScale = 0.5;
        _bgScrollView.maximumZoomScale = 3.0;
    }
    return _bgScrollView;
}

#pragma mark 重写initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.bgScrollView addSubview:self.imageView];
        [self addSubview:self.bgScrollView];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"%lf",self.imageView.frame.size.width);
    CGRect frame = self.imageView.frame;
    frame.origin.y = (self.bgScrollView.frame.size.height - self.imageView.frame.size.height) > 0 ? (self.bgScrollView.frame.size.height - self.imageView.frame.size.height) * 0.5 : 0;
    frame.origin.x = (self.bgScrollView.frame.size.width - self.imageView.frame.size.width) > 0 ? (self.bgScrollView.frame.size.width - self.imageView.frame.size.width) * 0.5 : 0;
    self.imageView.frame = frame;
    self.bgScrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);

}


@end
