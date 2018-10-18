//
//  LWPhotoBrowseView.m
//  LWPhotoAsset
//
//  Created by liwei on 2017/11/7.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWPhotoBrowseView.h"
#import "LWPhotoBrowseCollectionViewCell.h"
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图
@interface LWPhotoBrowseView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 块视图 */
@property (nonatomic,strong) UICollectionView * collectionView;
/** cell的size */
@property (nonatomic,assign) CGSize  itemSize;
/** 展示数组 */
@property (nonatomic,strong) NSMutableArray * showArray;
/** 顶部视图 */
@property (nonatomic,strong) UIView * topView;
/** 标签 */
@property (nonatomic,strong) UILabel * titleLabel;
/** 添加按钮 */
@property (nonatomic,strong) UIButton * addBtn;
/** 返回按钮 */
@property (nonatomic,strong) UIButton * backBtn;

- (void)backBtnClick:(UIButton *)btn; // 返回按钮点击
- (void)resetShowView; // 重置展示视图

@end
// ==========================================================================================================================================================================================
#pragma mark 图片资源预览视图
@implementation LWPhotoBrowseView

#pragma mark 懒加载展示数组
- (NSMutableArray *)showArray {
    if (_showArray == nil) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}
#pragma mark 懒加载添加按钮
- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor = [UIColor clearColor];
        [_addBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn addTarget:self action:@selector(pressEvent:) forControlEvents:UIControlEventTouchDown];
        [_addBtn addTarget:self action:@selector(unpressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _addBtn;
}
#pragma mark 懒加载返回按钮
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[LWAssetHelper imageBundleWithName:@"back_white"] forState:UIControlStateNormal];
        [_backBtn sizeToFit];
    }
    return _backBtn;
}
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f)];
        _topView.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:_topView.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.alpha = 0.2f;
        [_topView addSubview:bgView];
        CGFloat h = 30.0f;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame) - h - 10.0f, _topView.frame.size.width, h)];
        self.titleLabel.text = @"0/0";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:self.titleLabel];
        self.addBtn.frame = CGRectMake(_topView.frame.size.width - h - 10.0f, CGRectGetMaxY(_topView.frame) - h - 10.0f, h, h);
        [_topView addSubview:self.addBtn];
        h = 40.0f;
        self.backBtn.frame = CGRectMake(10, CGRectGetMaxY(_topView.frame) - h - 5.0, h, h);
        self.addBtn.center = CGPointMake(self.addBtn.center.x, self.backBtn.center.y);
        [_topView addSubview:self.backBtn];
    }
    return _topView;
}
#pragma mark 懒加载块视图
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 0.0f;
        collectionViewLayout.minimumInteritemSpacing = 0.0f;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.tag = 1000;
        [_collectionView registerClass:[LWPhotoBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"LWPhotoBrowseCollectionViewCell"];
    }
    return _collectionView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIWindow *window  = [UIApplication sharedApplication].keyWindow;
        [self addSubview:self.collectionView];
//        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.topView];
    }
    return self;
}

#pragma mark 展示视图
- (void)showViewAtView:(UIView *)supView {
    
    self.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    [supView addSubview:self];
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self resetShowView];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWPhotoBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWPhotoBrowseCollectionViewCell" forIndexPath:indexPath];
    if (self.showArray.count > indexPath.item) {
        LWPHAsset * asset = [self.showArray objectAtIndex:indexPath.item];
        NSInteger tag = indexPath.item;
        asset.tag = tag;
        cell.bgScrollView.frame = CGRectMake(5, 0, self.itemSize.width - 10, self.itemSize.height);
        UIImage *image = [LWAssetHelper originalImage:asset];
        cell.imageView.image = image;
        cell.bgScrollView.zoomScale = 1.0f;
        cell.bgScrollView.contentSize = CGSizeZero;
        cell.imageView.frame = CGRectMake(0, 0, self.itemSize.width - 10, self.itemSize.height);
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.center = cell.bgScrollView.center;
        cell.imageView.userInteractionEnabled = YES;
    }
    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 1000) {
        if (scrollView.contentOffset.x > self.frame.size.width * 1.5) { // 向后滚
            self.showIndex++;
            [self resetShowView];
        }
        else if (scrollView.contentOffset.x < self.frame.size.width * 0.5) // 向前滚
        {
            self.showIndex--;
            [self resetShowView];
        }
    }
}

#pragma mark 重置展示视图
- (void)resetShowView {
    LWPHAsset *preAsset = nil;
    LWPHAsset *midAsset = nil;
    LWPHAsset *nexAsset = nil;
    if (self.showIndex < 0) {
        self.showIndex = self.assetArray.count - 1;
    }
    if (self.showIndex > (self.assetArray.count - 1)) {
        self.showIndex = 0;
    }
    NSLog(@"%ld",self.showIndex);
    if (self.showIndex == 0) {
        preAsset = [self.assetArray lastObject];
    }
    else {
        preAsset = [self.assetArray objectAtIndex:self.showIndex - 1];
    }
    midAsset = [self.assetArray objectAtIndex:self.showIndex];
    if (self.showIndex == self.assetArray.count - 1) {
        nexAsset = [self.assetArray firstObject];
    }
    else {
        nexAsset = [self.assetArray objectAtIndex:self.showIndex + 1];
    }
    [self.showArray removeAllObjects];
    [self.showArray addObject:preAsset];
    [self.showArray addObject:midAsset];
    [self.showArray addObject:nexAsset];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.collectionView reloadData];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.showIndex + 1,self.assetArray.count];
    
    if (midAsset.isSelect == YES) {
        [self.addBtn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"selected_selected"] forState:UIControlStateNormal];
    }
    else {
        [self.addBtn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"selected_normal"] forState:UIControlStateNormal];
    }
    
}
#pragma mark 返回按钮点击
- (void)backBtnClick:(UIButton *)btn {
    if (self.block) {
        self.block(NO);
    }
    [self removeFromSuperview];
}
#pragma mark 添加按钮点击
- (void)addBtnClick:(UIButton *)btn {
   
    if (self.assetArray.count > self.showIndex) {
        LWPHAsset * asset = [self.assetArray objectAtIndex:self.showIndex];
        __block BOOL isHave = NO;
        __block NSUInteger index = 0;
        [self.selectedArray enumerateObjectsUsingBlock:^(LWPHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj == asset) { // 已经存在
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
                    [self.vc presentViewController:controller animated:YES completion:^{
                        
                    }];
                }
                return;
            }
            asset.isSelect = YES;
            asset.originalImage = [LWAssetHelper originalImage:asset];
            [self.selectedArray addObject:asset];
            [btn setBackgroundImage:[LWAssetHelper imageBundleWithName:@"selected_selected"] forState:UIControlStateNormal];
        }
        if (self.block) {
            self.block(YES);
        }
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
    }];
    
}

@end
// ==========================================================================================================================================================================================
