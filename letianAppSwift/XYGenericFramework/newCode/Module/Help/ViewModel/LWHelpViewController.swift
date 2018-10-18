//
//  LWHelpViewController.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/13.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助视图控制器
class LWHelpViewController: LWBaseViewController {

    lazy var navItemView: LWHelpNavTitleView = {
        let view = LWHelpNavTitleView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    /// 滚动视图
    //MARK:  滚动视图
    lazy var scrollerView: UIScrollView = {
        let view = UIScrollView.init(frame: self.view.bounds)
        view.backgroundColor = UIColor.clear
        view.bounces = false
        view.isPagingEnabled = true
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    //MARK: 懒加载送取视图
    /// 送取视图
    lazy var fetchView: LWHelpContentView = {
        let view = LWHelpContentView()
        view.backgroundColor = .clear
        view.viewType = .fetch
        return view
    }()
    //MARK: 懒加载悬赏视图
    /// 悬赏视图
    lazy var rewardView: LWHelpContentView = {
        let view = LWHelpContentView()
        view.backgroundColor = .clear
        view.viewType = .reward
        return view
    }()
    //MARK: 发布按钮
    // 发布按钮
    lazy var writeBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setBackgroundImage(UIImage.init(named: "help_write"), for: .normal)
        btn.addTarget(self, action: #selector(writeBtnClick), for: .touchUpInside)
        return btn
    }()
    //MARK: 懒加载出售视图
    /// 出售视图
    lazy var sellView: LWHelpContentView = {
        let view = LWHelpContentView()
        view.backgroundColor = .clear
        view.viewType = .sell
        return view
    }()
    lazy var leftNavView: UIView = {
        let leftImage = UIImage.init(named: "help_nav_left")
        let view = UIView()
        let leftImageView = UIImageView.init(image: leftImage)
        view.frame = CGRect.init(x: 0, y: 0, width: leftImageView.frame.size.width + 3.0, height: leftImageView.frame.size.height)
        view.addSubview(UIImageView.init(image: leftImage))
        let wh :CGFloat = 7.0
        let redLabel = UILabel.init(frame: CGRect.init(x: view.frame.size.width - wh, y: 0, width: wh, height: wh))
        redLabel.backgroundColor = .red
        redLabel.layer.masksToBounds = true
        redLabel.layer.cornerRadius = wh / 2.0
        view.addSubview(redLabel)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(leftNavClick)))
        return view
    }()
    lazy var navLeftView: LWHelpLeftNavView = {
        let view = LWHelpLeftNavView.init(frame: (UIApplication.shared.keyWindow?.bounds)!)
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    //MARK: - 重写viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViewSubviews()
        
    }
    //MARK: - 重写viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutViewSubviews()
    }
}
// =================================================================================================================================
// MARK: - 帮助视图控制器
extension LWHelpViewController {
    /// 添加子控件
    //MARK: - 添加子控件
    func addViewSubviews() {
         navItemView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width - 150.0, height: 44.0)
         self.navigationItem.titleView = navItemView

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavView)
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftImage, style: .plain, target: self, action: #selector(leftNavClick))
        fetchView.VC = self
        scrollerView.addSubview(fetchView)
        rewardView.VC = self
        scrollerView.addSubview(rewardView)
        sellView.VC = self
        scrollerView.addSubview(sellView)
        self.view.addSubview(scrollerView)
        self.perform(#selector(reloadView), with: self, afterDelay: 0.25)
        view.addSubview(writeBtn)
        
    }
    @objc private func leftNavClick() {
        navLeftView.showView()
    }
    @objc private func writeBtnClick() {
        let vc = LWHelpIssueContentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc private func reloadView() {
        
        navItemView.viewType = LWHelpNavTitleViewType(rawValue: 2)!
        navItemView.layoutViewSubviews()
        rewardView.reloadView()
        scrollerView.contentOffset = CGPoint.init(x: 1 * scrollerView.frame.size.width, y: 0.0)
    }
    
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        var x :CGFloat = 0.0
        var y :CGFloat = 0.0
        var w :CGFloat = self.view.frame.size.width
        var h :CGFloat = self.view.frame.size.height
        scrollerView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        x = 0.0
        fetchView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        x = scrollerView.frame.size.width
        rewardView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        x = scrollerView.frame.size.width * 2
        sellView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        scrollerView.contentSize = CGSize.init(width: w * 3, height: h)
        
        w = 35.0
        h = 35.0
        x = self.view.frame.size.width - w - 30.0
        y = self.view.frame.size.height - h - 30.0
        writeBtn.frame = CGRect.init(x: x, y: y, width: w, height: h)
    }
    //MARK: - 修改图片尺寸
    public func imageScaleToSize(image: UIImage) -> UIImage{
        let size = image.size
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        //取得当前的上下文，这里得到的就是上面刚创建的图片上下文
        let context = UIGraphicsGetCurrentContext()
    
        UIColor.red.setFill()
        let bigRadius: CGFloat = 2 //大圆半径
        let centerX:CGFloat = size.width - 2 //圆心
        let centerY:CGFloat = 2 //圆心
        let center = CGPoint.init(x: centerX, y: centerY)
        let endAngle = CGFloat(M_PI * 2)
        
        context?.addArc(center: center, radius: bigRadius, startAngle: 0, endAngle: endAngle, clockwise: false)
        context?.fillPath()

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
// =================================================================================================================================
// MARK: - 帮助视图控制器LWHelpNavTitleViewDelegate
extension LWHelpViewController : LWHelpNavTitleViewDelegate {
    
    // MARK: 点击某个item
    func helpNavTitleView(view: LWHelpNavTitleView, viewType: LWHelpNavTitleViewType) {
        let index :CGFloat = CGFloat(viewType.rawValue - 1)
        scrollerView.contentOffset = CGPoint.init(x: index * scrollerView.frame.size.width, y: 0.0)
        if navItemView.viewType == .fetch {
            fetchView.reloadView()
        }
        else if navItemView.viewType == .reward {
            rewardView.reloadView()
        }
        else if navItemView.viewType == .sell {
            sellView.reloadView()
        }
    }
}
// =================================================================================================================================
// MARK: - 帮助视图控制器UIScrollViewDelegate
extension LWHelpViewController : UIScrollViewDelegate {
    /// 视图结束轮动
    //MARK:  视图结束轮动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contextOffsetX = scrollView.contentOffset.x + 10.0
        let index = (contextOffsetX / scrollView.frame.size.width) + 1
        navItemView.viewType = LWHelpNavTitleViewType(rawValue: Int(index))!
        navItemView.layoutViewSubviews()
        if navItemView.viewType == .fetch {
            fetchView.reloadView()
        }
        else if navItemView.viewType == .reward {
            rewardView.reloadView()
        }
        else if navItemView.viewType == .sell {
            sellView.reloadView()
        }
    }
}
// =================================================================================================================================
// MARK: - 帮助视图控制器LWHelpLeftNavViewDelegate
extension LWHelpViewController : LWHelpLeftNavViewDelegate {

    func helpLeftNavView(view: LWHelpLeftNavView, clickType: LWHelpLeftNavViewClickType) {
        if clickType == LWHelpLeftNavViewClickType.help {
            
        }
        else if clickType == LWHelpLeftNavViewClickType.manage {
            
        }
        else if clickType == LWHelpLeftNavViewClickType.msg {
            writeBtnClick()
        }
        else if clickType == LWHelpLeftNavViewClickType.writed {
            
        }
    }
}
// =================================================================================================================================
