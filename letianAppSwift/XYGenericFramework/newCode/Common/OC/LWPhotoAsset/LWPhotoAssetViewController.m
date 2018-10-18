//
//  LWPhotoAssetViewController.m
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWPhotoAssetViewController.h"
#import "LWAssetCollectionViewCell.h"
#import "LWPhotoAssetBottomView.h"
#import "LWPhotoBrowseView.h"
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器
@interface LWPhotoAssetViewController ()<CAAnimationDelegate>

/** 块视图 */
@property (nonatomic,strong) UICollectionView * collectionView;
/** 图片资源数组 */
@property (nonatomic,strong) NSMutableArray<LWPHAsset *> * assetArray;

/** cell的size */
@property (nonatomic,assign) CGSize  itemSize;
/** 完成按钮 */
@property (nonatomic,strong) UIButton * completeBtn;
/** 底部功能条 */
@property (nonatomic,strong) LWPhotoAssetBottomView * bottomBarView;
/** 动画图层数组 */
@property (nonatomic,strong) NSMutableArray<CALayer *> * animationLayerArray;

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器tools
@interface LWPhotoAssetViewController (tools)

- (void)addViewSubViews; // 添加自视图
- (void)layoutViewSubViews; // 布局自视图
- (void)checkSelectImages;  // 检查选择的图片
- (void)addBtnClick:(UIButton *)btn; // 添加按钮点击
- (void)completeBtnClick:(UIButton *)btn; // 完成按钮点击
- (void)cancelBtnClick:(UIButton *)btn;   // 取消按钮点击
- (void)pressEvent:(UIButton *)btn; // 按钮按下
- (void)unpressEvent:(UIButton *)btn; // 按钮松开
- (void)moveAnimationView:(UIView *)animationView toView:(UIView *)view; // 动画移动

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器UICollectionViewDelegateDataSourceFlowLayout
@interface LWPhotoAssetViewController (UICollectionViewDelegateDataSourceFlowLayout)<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器
@implementation LWPhotoAssetViewController
#pragma mark 懒加载图片资源数组
- (NSMutableArray *)assetArray {
    if (_assetArray == nil) {
        _assetArray = [NSMutableArray array];
        NSArray *array = [LWAssetHelper getSystemImageAssetArray];
        [_assetArray addObjectsFromArray:array];
    }
    return _assetArray;
}
#pragma mark 懒加载选择图片数组
- (NSMutableArray<LWPHAsset *> *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
#pragma mark 懒加载动画图层数组
- (NSMutableArray<CALayer *> *)animationLayerArray {
    if (_animationLayerArray == nil) {
        _animationLayerArray = [NSMutableArray array];
    }
    return _animationLayerArray;
}
#pragma mark 懒加载块视图
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 0.1f;
        collectionViewLayout.minimumInteritemSpacing = 0.1f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        [_collectionView registerClass:[LWAssetCollectionViewCell class] forCellWithReuseIdentifier:@"LWAssetCollectionViewCell"];
    }
    return _collectionView;
}
#pragma mark 底部功能条
- (LWPhotoAssetBottomView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[LWPhotoAssetBottomView alloc] initWithFrame:CGRectZero];
        _bottomBarView.backgroundColor = [UIColor whiteColor];
        [_bottomBarView.completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBarView.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBarView;
}
#pragma mark  重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self addViewSubViews];
}
#pragma mark 重写
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];;
    [self layoutViewSubViews];
}

#pragma mark 展示视图
- (void)showViewWithVC:(UIViewController *)vc {
    if (vc == nil) {
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [vc.navigationController presentViewController:self animated:YES completion:nil];
                NSLog(@"相册已授权打开");
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
                    [self openAuthorization:@"相册权限未开启" message:@"相册权限未开启，请在设置中选择当前应用,开启相册功能"];
                }
            });
        }
    }];
}

//判断是否开启了相册权限
- (void)openAuthorization:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:open];
    [alert addAction:cancel];
     UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    [topRootViewController presentViewController:alert animated:YES completion:nil];
    
}

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器tools
@implementation LWPhotoAssetViewController (tools)

#pragma mark 添加自视图
- (void)addViewSubViews {
    if (self.lineMaxCount <= 0) {
        self.lineMaxCount = 4; // 默认设置4个
    }
    CGFloat wh = (self.view.frame.size.width - self.lineMaxCount * 5.0f) / self.lineMaxCount;
    self.itemSize = CGSizeMake(wh, wh);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBarView];
    if (self.selectedArray.count > 0) {
        [self.selectedArray enumerateObjectsUsingBlock:^(LWPHAsset * _Nonnull obi, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.assetArray enumerateObjectsUsingBlock:^(LWPHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obi.tag == obj.tag) {
                    obj.isSelect = YES;
                    *stop = YES;
                }
            }];
        }];
    }
    CGFloat h = 50.0f;
    self.bottomBarView.frame = CGRectMake(0, self.view.frame.size.height - h, self.view.frame.size.width, h);
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMinY(self.bottomBarView.frame));
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assetArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}
#pragma mark 布局自视图
- (void)layoutViewSubViews {
    CGFloat h = 50.0f;
    self.bottomBarView.frame = CGRectMake(0, self.view.frame.size.height - h, self.view.frame.size.width, h);
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMinY(self.bottomBarView.frame));
    [self checkSelectImages];
}
#pragma mark 检查选择的图片
- (void)checkSelectImages {
    
    NSInteger count = self.selectedArray.count;
    NSString *countString = @"0";
    if (count <= 0) {
        countString = @"0";
    }
    else {
        countString = [NSString stringWithFormat:@"%ld",count];
    }
    NSString *allCountString = @"0";
    if (self.maxSelectCount <= 0) {
        allCountString = @"0";
    }
    else {
        allCountString = [NSString stringWithFormat:@"%ld",self.maxSelectCount];
    }
    NSString *string = [NSString stringWithFormat:@"确定%@/%@",countString,allCountString];
    [self.bottomBarView.completeBtn setTitle:string forState:UIControlStateNormal];
}
#pragma mark 添加按钮点击
- (void)addBtnClick:(UIButton *)btn {
   
    if (self.assetArray.count > btn.tag) {
        LWPHAsset * asset = [self.assetArray objectAtIndex:btn.tag];
        __block BOOL isHave = NO;
        __block NSUInteger index = 0;
        [self.selectedArray enumerateObjectsUsingBlock:^(LWPHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == btn.tag) { // 已经存在
                isHave = YES;
                index = idx;
                *stop = YES;
            }
        }];
        if (asset.isSelect == YES) {
            asset.isSelect = NO;
            if (isHave == YES) {
                [self.selectedArray removeObjectAtIndex:index];
            }
            [btn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"selected_normal"] forState:UIControlStateNormal];
        }
        else {
            if (self.selectedArray.count == self.maxSelectCount) {
                if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%ld张图片",self.maxSelectCount] preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:controller animated:YES completion:^{
                        
                    }];
                }
                return;
            }
            asset.isSelect = YES;
            asset.originalImage = [LWAssetHelper originalImage:asset];
            [self.selectedArray addObject:asset];
            [btn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"show_selected_selected"] forState:UIControlStateNormal];
            [btn.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    if (obj.tag == 1000) {
                        [self moveAnimationView:obj toView:self.bottomBarView.completeBtn];
                        *stop = YES;
                    }
                }
            }];

        }
        [self checkSelectImages];
    }
}
#pragma mark 按钮按下
- (void)pressEvent:(UIButton *)btn {
    
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
}
#pragma mark 按钮松开
- (void)unpressEvent:(UIButton *)btn {
    // 恢复
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self checkSelectImages];
    }];
    
}
#pragma mark 动画移动
- (void)moveAnimationView:(UIView *)animationView toView:(UIView *)view{
    // 图层
    CALayer *animationLayer = [CALayer layer];
    animationLayer.contents = animationView.layer.contents;
    animationLayer.contentsGravity = kCAGravityResizeAspect;
    animationLayer.bounds = animationView.bounds;
   UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    [window.layer addSublayer:animationLayer];
    CGPoint beginPoint = [animationView.superview convertPoint:animationView.center toView:window];
    CGPoint endPoint = [view.superview convertPoint:view.center toView:window];
    animationLayer.position = beginPoint;
    // 路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:animationLayer.position];
    // 确定最高点
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, beginPoint.y - animationView.frame.size.height)];
    // 关键帧动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    
    // 往下抛的选装动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:5.0];
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 大小动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.2];
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation,rotateAnimation,scaleAnimation];
    groupAnimation.duration = 1.0f;
    // 设置动画后layer不会回到开始位置
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    // 设置代理
    groupAnimation.delegate = self;
    [animationLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    [self.animationLayerArray addObject:animationLayer];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSArray *temp = [NSArray arrayWithArray:self.animationLayerArray];
    for (CALayer *layer in temp) {
        if (anim == [layer animationForKey:@"groupAnimation"]) {
            [layer removeFromSuperlayer];
            [self.animationLayerArray removeObject:layer];
            [self animationComplete];
        }
    }
}
- (void)animationComplete {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    [self.bottomBarView.completeBtn.layer addAnimation:scaleAnimation forKey:nil];
}
#pragma mark - 完成按钮点击
- (void)completeBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(photoAssetViewController:completeArray:)]) {
        [self.delegate photoAssetViewController:self completeArray:self.selectedArray];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 取消按钮点击
- (void)cancelBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(photoAssetViewControllerCancel:)]) {
        [self.delegate photoAssetViewControllerCancel:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图控制器UICollectionViewDelegateDataSourceFlowLayout
@implementation LWPhotoAssetViewController (UICollectionViewDelegateDataSourceFlowLayout)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWAssetCollectionViewCell" forIndexPath:indexPath];
    if (self.assetArray.count > indexPath.item) {
        LWPHAsset * asset = [self.assetArray objectAtIndex:indexPath.item];
        NSInteger tag = indexPath.item;
        asset.tag = tag;
        UIImage *image = [LWAssetHelper smallImageSize:self.itemSize asset:asset];
        cell.imageView.image = image;
        cell.imageView.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        cell.imageView.tag = 1000;
        cell.imageView.userInteractionEnabled = YES;
        CGFloat wh = 25.0f;
        cell.addBtn.tag = tag;
        cell.addBtn.frame = CGRectMake(self.itemSize.width - wh, 0, wh, wh);
        if (asset.isSelect == YES) {
            [cell.addBtn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"show_selected_selected"] forState:UIControlStateNormal];
        }
        else {
            [cell.addBtn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"show_selected_normal"] forState:UIControlStateNormal];
        }
        [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addBtn addTarget:self action:@selector(pressEvent:) forControlEvents:UIControlEventTouchDown];
        [cell.addBtn addTarget:self action:@selector(unpressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LWPhotoBrowseView *view = [[LWPhotoBrowseView alloc] initWithFrame:self.collectionView.frame];
    view.assetArray = self.assetArray;
    view.selectedArray = self.selectedArray;
    view.maxSelectCount = self.maxSelectCount;
    view.vc = self;
    view.showIndex = indexPath.item;
    view.block = ^(BOOL isChange) {
        if (isChange == YES) {
            [self checkSelectImages];
        }
        else {
            [self.collectionView reloadData];
        }
    };
    [view showViewAtView:self.view];
}

@end
// ==========================================================================================================================================================================================
