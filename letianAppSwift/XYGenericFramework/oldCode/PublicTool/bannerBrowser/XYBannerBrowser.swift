//
//  XYBannerView.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 16/10/18.
//  Copyright © xiaoyi6409. All rights reserved.
//
// 使用注意事项：在离开XYBannerBrowser的对应VC前，需要调用browserRelease()方法释放资源
import UIKit
import SDWebImage
class XYBannerBrowser: UIView,UIScrollViewDelegate {
    
    //占位图
    private let placeHolderImage:UIImage = #imageLiteral(resourceName: "XYplaceHolderImage.png")
    private let errorImage:UIImage = #imageLiteral(resourceName: "XYImageError.png")
    
    //scrollView
    private var contentScrollView: UIScrollView!
    //当前展示的图片View
    private var currentImageView:   UIImageView!
    //前一张图片View
    private var lastImageView:      UIImageView!
    //下一张图片View
    private var nextImageView:      UIImageView!
    //页数指示器
    private var pageIndicator:      UIPageControl!
    //轮播timmer
    private var timer:              Timer?
    //点击事件代理
    public var delegate: XYBannerViewDelegate?
    //轮播间隔设置
    private let timeInterval = 3.0
    

    //网络图片数组
    private var imageArrayUrl:[String]!

    // 当前显示的第几张图片
    private var indexOfCurrentImage: Int!  {
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            self.pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    
    
    //MARK:- 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, imageArrayUrl: [String]) {
        self.init(frame: frame)
        self.backgroundColor = .gray
        
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.imageArrayUrl = imageArrayUrl
        
        self.setUpCircleView(imageUrlArr: imageArrayUrl)

    }
    
    
    //MARK: - 重新设置图片数组
    public func resetImageUrlArray(imageArrayUrl: [String]){
        timer?.invalidate()
        timer = nil
        self.imageArrayUrl = imageArrayUrl
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        
        contentScrollView.isScrollEnabled = !(imageArrayUrl.count == 1)
        self.pageIndicator.frame = CGRect(x:self.frame.size.width/2 - 13 * CGFloat(imageArrayUrl.count)/2, y:self.frame.size.height - 21, width:13 * CGFloat(imageArrayUrl.count), height:12)
        self.pageIndicator?.numberOfPages = self.imageArrayUrl.count
        if imageArrayUrl.count == 1{
            pageIndicator.isHidden = true
        }
        
        self.setScrollViewOfImage()
        if timer == nil && imageArrayUrl.count > 1{
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    

    //MARK:- 设置循环轮播
    private func setUpCircleView(imageUrlArr:[String]) {
        self.contentScrollView = UIScrollView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.size.height))
        contentScrollView.contentSize = CGSize(width:self.frame.size.width * 3, height:0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = UIColor.white
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isScrollEnabled = !(imageUrlArr.count == 1)
        self.addSubview(contentScrollView)
        
        self.currentImageView = UIImageView(frame:CGRect(x:self.frame.size.width, y:0, width:self.frame.size.width, height:self.frame.size.height))
        currentImageView.isUserInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.scaleAspectFill
        currentImageView.clipsToBounds = true
        contentScrollView.addSubview(currentImageView)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapAction(tap:)))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView(frame:CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.size.height))
        lastImageView.contentMode = UIViewContentMode.scaleAspectFill
        lastImageView.clipsToBounds = true
        contentScrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView(frame: CGRect(x:self.frame.size.width * 2, y:0, width:self.frame.size.width, height:self.frame.size.height))
        nextImageView.contentMode = UIViewContentMode.scaleAspectFill
        nextImageView.clipsToBounds = true
        contentScrollView.addSubview(nextImageView)
        
        contentScrollView.setContentOffset(CGPoint(x:self.frame.size.width, y:0), animated: false)
        
        //设置分页指示器
        self.pageIndicator = UIPageControl(frame: CGRect(x:self.frame.size.width/2 - 13 * CGFloat(imageUrlArr.count)/2, y:self.frame.size.height - 21, width:13 * CGFloat(imageUrlArr.count), height:12))
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = imageUrlArr.count
        pageIndicator.backgroundColor = UIColor.clear
        
        self.addSubview(pageIndicator)
        
        if imageUrlArr.count == 1{
            pageIndicator.isHidden = true
        }
        
        setScrollViewOfImage()
        
        if imageUrlArr.count > 1{
        //设置计时器
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: 设置图片
    private func setScrollViewOfImage(){
        if  imageArrayUrl.count > 0{
            
            //当前图片设置
            let currentUrl = imageArrayUrl[self.indexOfCurrentImage]//+"?x-oss-process=image/resize,w_\(pictureScale)"
            
            if let currentImageUrl = URL(string: currentUrl){
                self.currentImageView.sd_setImage(with: currentImageUrl, placeholderImage: placeHolderImage)
            }else{
                self.currentImageView.image = errorImage
            }
            
            
            //下一张图片设置
            let nextUrl = imageArrayUrl[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
            
            if let nextImageUrl = URL(string: nextUrl){
                self.nextImageView.sd_setImage(with: nextImageUrl, placeholderImage: placeHolderImage)
            }else{
                self.nextImageView.image = errorImage
            }
            
            
            //上一张图片设置
            let lastUrl = imageArrayUrl[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
            
            if let lastImageUrl = URL(string: lastUrl){
                self.lastImageView.sd_setImage(with: lastImageUrl, placeholderImage: placeHolderImage)
            }else{
                self.lastImageView.image = errorImage
            }
            
            
            
        }
    }
    
    //MARK: - 得到上一张图片的下标
    private func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArrayUrl.count - 1
        }else{
            return tempIndex
        }
    }
    
    //MARK: -  得到下一张图片的下标
    private func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArrayUrl.count ? tempIndex : 0
    }
    
    //MARK: - 事件触发方法
    @objc   func timerAction() {
        // 当只有一张图片的时候，不进行轮播
        if imageArrayUrl.count > 1{
            contentScrollView.setContentOffset(CGPoint(x:self.frame.size.width*2, y:0), animated: true)
        }
        
        //print("timer--->",indexOfCurrentImage)
        
    }
    
    //MARK: - 点击图片
    @objc func imageTapAction(tap: UITapGestureRecognizer){
        self.delegate?.didClickCurrentImage!(currentIndex: indexOfCurrentImage)
    }
    
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x:self.frame.size.width, y:0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - 时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
    
    
    //MARK: - 释放timer，在调用该View的viewdisappear中使用
    func browserRelease(){
        self.timer?.invalidate()
        self.timer = nil
        if self.delegate != nil{
        self.delegate = nil
        }
    }
    
    deinit {
        print("--->释放XYBannerBrowser")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




//MARK:- Protocol 点击图片的代理方法
@objc protocol XYBannerViewDelegate {
    
    @objc optional func didClickCurrentImage(currentIndex: Int)
    
}




