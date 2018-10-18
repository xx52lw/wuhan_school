//
//  LWHelpIssueContentViewController.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/14.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助发布内容视图控制器
class LWHelpIssueContentViewController: LWBaseViewController {

    // MARK: 列表视图
    /// 列表视图
    lazy var tableView : UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        return view
    }()
    /// 内容视图
    //MARK:  内容视图
    lazy var contentView: LWHelpIssueMsgView = {
        let view = Bundle.main.loadNibNamed("LWHelpIssueMsgView", owner: self, options: nil)?.first
        return view as! LWHelpIssueMsgView
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
// MARK: - 帮助发布内容视图控制器
extension LWHelpIssueContentViewController {
    /// 添加子控件
    //MARK: - 添加子控件
    func addViewSubviews() {
        self.title = "信息发布"
        contentView.VC = self
        contentView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 900)
        self.view.addSubview(tableView)
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        let x :CGFloat = 0.0
        let y :CGFloat = 0.0
        let w :CGFloat = self.view.frame.size.width
        let h :CGFloat = self.view.frame.size.height
        tableView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        tableView.reloadData()
    }
}

// =================================================================================================================================
// MARK: - 帮助发布内容视图控制器UITableViewDelegateDataSource
extension LWHelpIssueContentViewController :UITableViewDelegate, UITableViewDataSource {
    
    /// cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // MARK: cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 925
    }
    
    // MARK: cell样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LWHelpIssueContentViewController"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            let bgView = UIView()
            bgView.backgroundColor = .clear
            bgView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 925)
            contentView.frame = bgView.bounds
            bgView.addSubview(contentView)
            cell?.contentView.addSubview(bgView)
        }
        return cell!
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                self.view.endEditing(true)
    }
}
// =================================================================================================================================
