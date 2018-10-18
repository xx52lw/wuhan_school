//
//  LWHelpNavTitleView.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/13.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助视图控制器标题视图样式
public enum LWHelpNavTitleViewType : Int {
    /// 无样式
    case none
    /// 取送
    case fetch
    /// 悬赏
    case reward
    /// 出售
    case sell
}
// =================================================================================================================================
// MARK: - 帮助视图控制器标题视图代理属性
protocol LWHelpNavTitleViewDelegate :NSObjectProtocol {
    /// 点击某个item
    func helpNavTitleView(view : LWHelpNavTitleView ,viewType: LWHelpNavTitleViewType)
}
// =================================================================================================================================
// MARK: - 帮助视图控制器标题视图
class LWHelpNavTitleView: UIView {

    // MARK:取送按钮
    /// 取送按钮
    lazy var fetchItem: LWHelpNavTitleViewItem = {
        let item = LWHelpNavTitleViewItem()
        item.itemLabel.text = "取送"
        item.tag = LWHelpNavTitleViewType.fetch.rawValue
        item.coverBtn.tag = item.tag
        item.coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
        return item
    }()
    // MARK:悬赏按钮
    /// 悬赏按钮
    lazy var rewardItem: LWHelpNavTitleViewItem = {
        let item = LWHelpNavTitleViewItem()
        item.itemLabel.text = "悬赏"
        item.tag = LWHelpNavTitleViewType.reward.rawValue
        item.coverBtn.tag = item.tag
        item.coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
        return item
    }()
    // MARK:出售按钮
    /// 出售按钮
    lazy var sellItem: LWHelpNavTitleViewItem = {
        let item = LWHelpNavTitleViewItem()
        item.itemLabel.text = "出售"
        item.tag = LWHelpNavTitleViewType.sell.rawValue
        item.coverBtn.tag = item.tag
        item.coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
        return item
    }()
    
    // MARK:样式
    /// 样式（默认悬赏）
    var viewType :LWHelpNavTitleViewType = .reward
    
    /// 代理属性
    weak var delegate : LWHelpNavTitleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fetchItem)
        addSubview(rewardItem)
        addSubview(sellItem)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewSubviews()
       
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        fetchItem.isSelected = false
        rewardItem.isSelected = false
        sellItem.isSelected = false
        if viewType == .fetch {
            fetchItem.isSelected = true
        }
        else if viewType == .reward {
            rewardItem.isSelected = true
        }
        else if viewType == .sell {
            sellItem.isSelected = true
        }
        
        // 悬赏
        var x :CGFloat = 0.0
        let y :CGFloat = 0.0
        let w :CGFloat = LWUITools.sizeWithStringFont("两个", font: UIFont.boldSystemFont(ofSize: 18.0), maxSize: CGSize.init(width: 100, height: 100)).width + 25.0
        let h :CGFloat = self.frame.size.height
        x = (self.frame.size.width - w) / 2.0
        rewardItem.frame = CGRect.init(x: x, y: y, width: w, height: h)
        rewardItem.layoutViewSubviews()
        // 送取
        x = rewardItem.frame.minX - w
        fetchItem.frame = CGRect.init(x: x, y: y, width: w, height: h)
        fetchItem.layoutViewSubviews()
        // 出售
        x = rewardItem.frame.maxX
        sellItem.frame = CGRect.init(x: x, y: y, width: w, height: h)
        sellItem.layoutViewSubviews()
        
    }
    @objc func coverBtnClick(btn: UIButton) {
    
        if viewType == LWHelpNavTitleViewType(rawValue: btn.tag)! {
            return
        }
        viewType = LWHelpNavTitleViewType(rawValue: btn.tag)!
        layoutViewSubviews()
        delegate?.helpNavTitleView(view: self, viewType: viewType)
    }

}
// =================================================================================================================================
// MARK: - 帮助视图控制器标题视图
class LWHelpNavTitleViewItem: UIView {
    
    /// 是否选中
    var isSelected = false
    
    // MARK: 覆盖按钮
    /// 覆盖按钮
    lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    // MARK: 标签
    /// 标签
    lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    // MARK: 下划线
    /// 下划线
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(itemLabel)
        addSubview(lineView)
        addSubview(coverBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        
        if isSelected {
            itemLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            lineView.isHidden = false
        }
        else {
            itemLabel.font = UIFont.systemFont(ofSize: 17.0)
            lineView.isHidden = true
        }
        
        var x :CGFloat = 0.0
        var y :CGFloat = 0.0
        var w :CGFloat = self.frame.size.width
        var h :CGFloat = self.frame.size.height
        coverBtn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
        itemLabel.frame =  CGRect.init(x: x, y: y, width: w, height: h)
        w = LWUITools.sizeWithStringFont("两个", font: itemLabel.font, maxSize: CGSize.init(width: w, height: h)).width - 8.0
        h = 2.5
        x = (self.frame.size.width - w) / 2.0
        y = self.frame.size.height - h - 6.0
        lineView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
    }
    
}
// =================================================================================================================================
