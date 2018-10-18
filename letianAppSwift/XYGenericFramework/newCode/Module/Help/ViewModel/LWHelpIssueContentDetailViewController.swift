//
//  LWHelpIssueContentDetailViewController.swift
//  LoterSwift
//
//  Created by liwei on 2018/10/16.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助发布内容详情视图控制器
class LWHelpIssueContentDetailViewController: LWBaseViewController {

    /// 信息主键
    //MARK:  信息主键
    var UserMsgID = ""
    /// cell 高度
    //MARK:  cell 高度
    var cellHeight :CGFloat = 0
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
    /// 内容视图模型
    //MARK:  内容视图模型
    var contentModel = LWHelpIssueContentDetailModel()
    /// 内容视图
    //MARK:  内容视图
    lazy var contentView: LWHelpContentDetailView = {
        let view = Bundle.main.loadNibNamed("LWHelpContentDetailView", owner: self, options: nil)?.first
        return view as! LWHelpContentDetailView
    }()
    //MARK: - 重写viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViewSubviews()
        let url = LWHelpIssueContentDetailModelUrl + UserMsgID
        contentView.isHidden = false
        LWProgressHUD.show(infoStr: nil)
        LWNetWorkingTool<LWHelpIssueContentDetailModel>.getDataFromeServiceRequest(url: url, successBlock: { (jsonModel) in
            LWProgressHUD.dismiss()
            self.contentModel = jsonModel!
            self.layoutViewSubviews()
        }) { (error) in
            LWProgressHUD.dismiss()
        }
        
    }
    //MARK: - 重写viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
}
// =================================================================================================================================
// MARK: - 帮助发布内容详情视图控制器
extension LWHelpIssueContentDetailViewController {
    /// 添加子控件
    //MARK: - 添加子控件
    func addViewSubviews() {
        self.title = "详情"
        self.view.addSubview(tableView)
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        let x :CGFloat = 0.0
        let y :CGFloat = 0.0
        let w :CGFloat = self.view.frame.size.width
        let h :CGFloat = self.view.frame.size.height
        self.tableView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        cellHeight = 585.0
        contentView.frame = CGRect.init(x: x, y: y, width: w, height: cellHeight)
        contentView.isHidden = false
        contentView.contactBtn.isHidden = false
        let contentHeight = contentView.contentLabel.frame.size.height
        let font = contentView.contentLabel.font
        let testHeight = LWUITools.sizeWithStringFont(contentModel.MsgContent, font: font!, lineSpacing: 15.0, maxSize: CGSize.init(width: contentView.contentLabel.frame.size.width, height: 2000.0)).height
        if testHeight > contentHeight {
            contentView.contentHeightConstrant.constant = contentView.contentHeightConstrant.constant + testHeight - contentHeight
        }
        cellHeight = contentView.frame.size.height
        tableView.reloadData()
    }
}

// =================================================================================================================================
// MARK: - 帮助发布内容视图控制器UITableViewDelegateDataSource
extension LWHelpIssueContentDetailViewController :UITableViewDelegate, UITableViewDataSource {
    
    /// cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // MARK: cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // MARK: cell样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LWHelpIssueContentDetailViewController"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            let bgView = UIView()
            bgView.backgroundColor = .clear
            bgView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: cellHeight)
            contentView.frame = bgView.bounds
            bgView.addSubview(contentView)
            contentView.contentModel = contentModel
            cell?.contentView.addSubview(bgView)
        }
        return cell!
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
// =================================================================================================================================
