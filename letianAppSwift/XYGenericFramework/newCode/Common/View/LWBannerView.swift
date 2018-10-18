//
//  LWBannerView.swift
//  LoterSwift
//
//  Created by liwei on 2018/6/28.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - banner视图代理属性
protocol LWBannerViewDelegate :NSObjectProtocol {
    /// 点击某个banner
    func bannerViewClick(view : LWBannerView ,selectIndex: Int)
}
// =================================================================================================================================
// MARK: - banner视图
class LWBannerView: UIView {
    
    /// banner数组
    var bannerArray = [LWBannerViewModel]()
    /// 代理属性
    weak var delegate : LWBannerViewDelegate?
    /// 是否自动定时(默认开启)
    var isTimer = true
    /// 是否自动定时时间(必须是整数时间默认3s)
    var time = 3
    /// 是否显示页码(默认显示)
    var isShowPage = true
    /// 页码默认颜色(默认灰色)
    var currentPageIndicatorTintColor = UIColor.gray
    /// 页码选择颜色(默认白色)
    var pageIndicatorTintColor = UIColor.white
    /// 布局视图
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0 // 行间距
        layout.minimumInteritemSpacing = 0 // 列间距
        layout.scrollDirection = .horizontal
        let collectview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectview.register(LWBannerViewCell.self, forCellWithReuseIdentifier: "LWBannerViewCell")
        collectview.backgroundColor = UIColor.clear
        collectview.showsVerticalScrollIndicator = false
        collectview.delegate = self
        collectview.dataSource = self
        collectview.isPagingEnabled = true
        //        collectview.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom:0, right: 0)
        return collectview
    }()
    /// 页数控制器
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
    
    /// 私有属性
    private var selfTime = 0
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(pageControl)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    /// 展示banner
    func showBanner() {
        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        pageControl.frame = CGRect.init(x: 0, y: self.bounds.size.height - 20.0, width: self.bounds.size.width, height: 20.0)
        pageControl.numberOfPages = bannerArray.count
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        collectionView.reloadData()
        beginTimer()
    }
    func dismissBanner() {
        stopTimer()
    }
    private func beginTimer()  {
        if bannerArray.count < 2 {
            return
        }
        LWRemoveNotification(self, NotificationName: LWTimerNotification)
        LWAddNotification(self, selector: #selector(scrollBanner), NotificationName: LWTimerNotification)
    }
    func stopTimer() {
        LWRemoveNotification(self, NotificationName: LWTimerNotification)
    }
}
// =================================================================================================================================
// MARK: - banner视图
extension LWBannerView {
    
   @objc func scrollBanner() {
        if selfTime == time {
            selfTime = 0
            currentIndex = currentIndex + 1
            if bannerArray.count > currentIndex {
                pageControl.currentPage = currentIndex
                collectionView.scrollToItem(at: IndexPath.init(row: pageControl.currentPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
            else {
                currentIndex = 0;
                pageControl.currentPage = currentIndex
                collectionView.scrollToItem(at: IndexPath.init(row: pageControl.currentPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
        }
        else {
            selfTime = selfTime + 1;
         }
    }
}
// =================================================================================================================================
// MARK: - UICollectionView的代理和数据源方法
extension LWBannerView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
 
    // 分组个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // 每组元素个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerArray.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    // 每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    // 设置元素样式
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LWBannerViewCell", for: indexPath) as! LWBannerViewCell
        cell.backgroundColor = UIColor.clear
        let dataModel = bannerArray[indexPath.row] as LWBannerViewModel
        cell.imageView.frame = CGRect.init(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        if dataModel.imageUrl.count > 0 {
            UIImage.imageUrlAndPlaceImage(imageView: cell.imageView, stringUrl: dataModel.imageUrl, placeholdImage: LWGlobalPlaceHolderImage)
        }
        else {
            cell.imageView.image = dataModel.image
        }
        return cell
    }
    // 选择某个cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = bannerArray[indexPath.row] as LWBannerViewModel
        delegate?.bannerViewClick(view: self, selectIndex: dataModel.index)
    }
    // 开始滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    // 结束滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        selfTime = 0
        var index  = Int((collectionView.contentOffset.x + collectionView.frame.size.width * 0.5) / collectionView.frame.size.width)
        if index <= 0 {
            index = 0
        }
        if index >= bannerArray.count {
            index = bannerArray.count - 1;
        }
        pageControl.currentPage = index
        currentIndex = pageControl.currentPage
        beginTimer()
    }
    
}


// =================================================================================================================================
// MARK: - banner视图模型
class LWBannerViewModel: NSObject {
    
    /// 图片URL
    var imageUrl = ""
    /// 图片名称
    var image = UIImage()
    /// 索引
    var index = 0;
    
    required override init() {
        
    }
    
}
// =================================================================================================================================
// MARK: - banner视图cell
class LWBannerViewCell: UICollectionViewCell {
    // MARK: 懒加载图片
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    // MARK: 重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
// =================================================================================================================================
