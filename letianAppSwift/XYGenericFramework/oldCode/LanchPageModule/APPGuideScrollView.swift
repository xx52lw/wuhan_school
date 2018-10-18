//
//  APPGuideScrollView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/3.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class APPGuideScrollView: UIView,UIScrollViewDelegate {

    private var imageNames = ["guide1", "guide2", "guide3","guide4"]

    let doneBtnHeight = cmSizeFloat(60)
    let doneImage = #imageLiteral(resourceName: "guideBtnImage")
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var doneButton: UIButton!
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化
        self.initScrollView()
        self.initPageViews()
        self.initPageControl()
    }
    
    //MARK: - 初始化 scrollView
    func initScrollView() {
        scrollView = UIScrollView(frame: self.frame)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * CGFloat(imageNames.count), height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.addSubview(scrollView)
    }
    
    //MARK: - 初始化图片View
    func initPageViews() {
        for index in 0..<imageNames.count {
            let introduceImageView = UIImageView(frame: self.frame)
            introduceImageView.frame.origin.x = SCREEN_WIDTH * CGFloat(index)
            introduceImageView.image = UIImage(named: imageNames[index])
            self.scrollView.addSubview(introduceImageView)
            
            if index == imageNames.count - 1 {
                introduceImageView.isUserInteractionEnabled = true
                doneButton = UIButton(frame: CGRect(x: SCREEN_WIDTH/2 - doneImage.size.width/2, y: SCREEN_HEIGHT*4/5, width: doneImage.size.width, height: doneImage.size.height))
                doneButton.setImage(doneImage, for: .normal)
                doneButton.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside)
                introduceImageView.addSubview(doneButton)
                
                let btnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: doneImage.size.width, height: doneImage.size.height))
                btnLabel.textAlignment = .center
                btnLabel.font = cmSystemFontWithSize(18)
                btnLabel.textColor = MAIN_WHITE
                btnLabel.text = "立即开启"
                doneButton.addSubview(btnLabel)
            }
            
        }
    }
    
    //初始化 pageControl
    func initPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 80, width: SCREEN_WIDTH, height: 10))
        //pageControl.currentPageIndicatorTintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.8)
        pageControl.numberOfPages = imageNames.count
        self.addSubview(pageControl)
    }
    

    
    //实现 UIScrollViewDelegate 方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageFraction = self.scrollView.contentOffset.x / SCREEN_WIDTH
        self.pageControl.currentPage = Int(roundf(Float(pageFraction)))
    }
    
    
    
    
    @objc func doneButtonClick() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            self.removeFromSuperview()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")

        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
