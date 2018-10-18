//
//  LWHelpLeftNavView.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/14.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助视图控制器导航栏左侧功能视图样式
public enum LWHelpLeftNavViewClickType : Int {
    /// 无样式
    case none
    /// 互助
    case help
    /// 发布管理
    case manage
    /// 信息发布
    case msg
    /// 已发布
    case writed
}
// =================================================================================================================================
// MARK: - 帮助视图控制器导航栏左侧功能视图代理属性
protocol LWHelpLeftNavViewDelegate :NSObjectProtocol {
    /// 点击某个item
    func helpLeftNavView(view:LWHelpLeftNavView, clickType: LWHelpLeftNavViewClickType)
}
// =================================================================================================================================
// MARK: - 帮助视图控制器导航栏左侧功能视图
class LWHelpLeftNavView: UIView {

    /// 代理属性
    weak var delegate : LWHelpLeftNavViewDelegate?
    //MARK: 发布按钮
    // 发布按钮
    lazy var bgBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = LWBlackColor1
        btn.alpha = 0.3
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return btn
    }()
    // MARK: 懒加载背景视图
    /// 背景视图
    lazy var bgView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgBtn.isHidden = true
        addSubview(bgBtn)
        addSubview(bgView)
        layoutViewSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        var x :CGFloat = 0.0
        var y :CGFloat = 0.0
        var w :CGFloat = frame.size.width
        var h :CGFloat = frame.size.height
        bgBtn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        w = w * 0.6
        x = -w
        bgView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
        x = 40.0
        y = 65.0
        w = bgView.frame.size.width - x
        var str = "互助"
        let helpLabel = UILabel()
        helpLabel.textColor = LWBlackColor1
        helpLabel.textAlignment = .left
        helpLabel.backgroundColor = UIColor.clear
        helpLabel.font = UIFont.systemFont(ofSize: 20)
        helpLabel.text = str
        h = LWUITools.sizeWithStringFont(str, font: helpLabel.font, maxSize: CGSize.init(width: 100, height: 100)).height
        helpLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        helpLabel.isUserInteractionEnabled = true
        helpLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(helpLabelClick)))
        bgView.addSubview(helpLabel)
        y = helpLabel.frame.maxY + 25.0
        str = "发布管理"
        let manageLabel = UILabel()
        manageLabel.textColor = LWBlackColor1
        manageLabel.textAlignment = .left
        manageLabel.backgroundColor = UIColor.clear
        manageLabel.font = UIFont.systemFont(ofSize: 14)
        manageLabel.text = str
        h = LWUITools.sizeWithStringFont(str, font: manageLabel.font, maxSize: CGSize.init(width: 100, height: 100)).height
        manageLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        manageLabel.isUserInteractionEnabled = true
        manageLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(manageLabelClick)))
        bgView.addSubview(manageLabel)
        y = manageLabel.frame.maxY + 25.0
        str = "· 信息发布"
        let msgLabel = UILabel()
        msgLabel.textColor = LWBlackColor2
        msgLabel.textAlignment = .left
        msgLabel.backgroundColor = UIColor.clear
        msgLabel.font = UIFont.systemFont(ofSize: 14)
        msgLabel.text = str
        h = LWUITools.sizeWithStringFont(str, font: msgLabel.font, maxSize: CGSize.init(width: 100, height: 100)).height
        msgLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        msgLabel.isUserInteractionEnabled = true
        msgLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(msgLabelClick)))
        bgView.addSubview(msgLabel)
        y = msgLabel.frame.maxY + 25.0
        str = "· 已发布"
        let writedLabel = UILabel()
        writedLabel.textColor = LWBlackColor2
        writedLabel.textAlignment = .left
        writedLabel.backgroundColor = UIColor.clear
        writedLabel.font = UIFont.systemFont(ofSize: 14)
        writedLabel.text = str
        h = LWUITools.sizeWithStringFont(str, font: msgLabel.font, maxSize: CGSize.init(width: 100, height: 100)).height
        writedLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        writedLabel.isUserInteractionEnabled = true
        writedLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(writedLabelClick)))
        bgView.addSubview(writedLabel)
        
        y = writedLabel.frame.maxY
        bgView.contentSize = CGSize.init(width: bgView.frame.size.width, height: max(bgView.frame.width, y))
    }
    
    /// 展示视图
    func showView() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        bgBtn.isHidden = false
        bgView.frame = CGRect.init(x: -bgView.frame.size.width, y: bgView.frame.origin.y, width: bgView.frame.size.width, height: bgView.frame.size.height)
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.frame = CGRect.init(x: 0, y: self.bgView.frame.origin.y, width: self.bgView.frame.size.width, height: self.bgView.frame.size.height)
        }) { (complete) in
            
        }
    }
    /// 取消视图
    @objc func dismissView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.frame = CGRect.init(x: -self.bgView.frame.size.width, y: self.bgView.frame.origin.y, width: self.bgView.frame.size.width, height: self.bgView.frame.size.height)
        }) { (complete) in
            self.bgBtn.isHidden = true
            self.removeFromSuperview()
        }
    }
   
    @objc func helpLabelClick() {
        delegate?.helpLeftNavView(view: self, clickType: LWHelpLeftNavViewClickType.help)
        dismissView()
    }
    @objc func manageLabelClick() {
        delegate?.helpLeftNavView(view: self, clickType: LWHelpLeftNavViewClickType.manage)
        dismissView()
    }
    @objc func msgLabelClick() {
        delegate?.helpLeftNavView(view: self, clickType: LWHelpLeftNavViewClickType.msg)
        dismissView()
    }
    @objc func writedLabelClick() {
        delegate?.helpLeftNavView(view: self, clickType: LWHelpLeftNavViewClickType.writed)
        dismissView()
    }
    
}
// =================================================================================================================================
