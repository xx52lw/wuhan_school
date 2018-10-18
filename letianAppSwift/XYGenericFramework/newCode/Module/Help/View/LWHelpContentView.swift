//
//  LWHelpContentView.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/13.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助视图
class LWHelpContentView: UIView {

    var VC : UIViewController?
    
    // MARK:样式
    /// 样式（默认悬赏）
    var viewType :LWHelpNavTitleViewType = .none
    /// 列表数组
    var cellArray = [LWHelpContentModel]()
    /// 当前页码
    var currentIndex = 1
    // MARK: 列表视图
    /// 列表视图
    lazy var tableView : UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.mj_header  = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshDate))
        view.mj_footer  = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreDate))
        view.mj_footer.isHidden = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewSubviews()
        
    }
    // MARK: 刷新视图
    /// 刷新视图
    func reloadView() {
        if cellArray.count > 0 || tableView.mj_header.state == .refreshing  || tableView.mj_footer.state == .refreshing {
            
        }
        else {
            tableView.mj_header.beginRefreshing()
            refreshDate()
        }
    }
    // MARK: 刷新数据
    /// 刷新数据
    @objc func refreshDate() {
        currentIndex = 1
        requestData()
    }
    // MARK: 加载更多数据
    /// 加载更多数据
    @objc func loadMoreDate() {
        currentIndex = currentIndex + 1
    }
    func requestData() {
        weak var wself = self
        // api/StuMsg/msglist/{type}/{page}
        var type = 1
        if viewType == .fetch {
            type = 1
        }
        else if viewType == .reward {
            type = 2
        }
        else if viewType == .sell {
            type = 3
        }
       let url = LWHelpContentListModelUrl + "/\(type)" + "/\(currentIndex)"
        LWNetWorkingTool<LWHelpContentListModel>.getDataFromeServiceRequest(url: url, successBlock: { jsonModel  in
            wself!.tableView.mj_header.endRefreshing()
            wself!.tableView.mj_footer.endRefreshing()
            if wself?.currentIndex == 1 {
                wself?.cellArray.removeAll()
            }
            if wself!.currentIndex > 1 {
                wself!.currentIndex = wself!.currentIndex - 1
            }
            guard let modelData = jsonModel   else {
                wself?.tableView.reloadData()
                return
            }
            wself?.tableView.mj_footer.isHidden = !modelData.hasMore
            for itemModel in modelData.list! {
                wself?.cellArray.append(itemModel)
            }
            wself?.tableView.reloadData()
        }) { (error) in
            wself!.tableView.mj_header.endRefreshing()
            wself!.tableView.mj_footer.endRefreshing()
            wself?.tableView.reloadData()
        }
    }
}
// =================================================================================================================================
// MARK: - 帮助视图
extension LWHelpContentView {
    /// 添加子控件
    //MARK: - 添加子控件
    func addViewSubviews() {
       addSubview(tableView)
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        tableView.frame = self.bounds
    }
}
// =================================================================================================================================
// MARK: - 帮助视图UITableViewDelegateDataSource
extension LWHelpContentView :UITableViewDelegate, UITableViewDataSource {
    
    /// cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    // MARK: cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LWHelpContenteViewCell.calCellHeight(cellModel: nil, cellWidth: tableView.frame.size.width)
    }
    
    // MARK: cell样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LWHelpContenteViewCell.createCell(tableView: tableView, identifier: "LWHelpContenteViewCell")
        var model = LWHelpContentModel()
        if cellArray.count > indexPath.row {
            model = cellArray[indexPath.row]
        }
        cell.cellModle = model
        return cell
    }
    // MARK: 选择cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var model = LWHelpContentModel()
        if cellArray.count > indexPath.row {
            model = cellArray[indexPath.row]
        }
        let vc = LWHelpIssueContentDetailViewController()
        vc.UserMsgID = model.UserMsgID
        self.VC?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// =================================================================================================================================
