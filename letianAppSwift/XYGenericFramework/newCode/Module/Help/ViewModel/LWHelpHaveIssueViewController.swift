//
//  LWHelpHaveIssueViewController.swift
//  LoterSwift
//
//  Created by liwei on 2018/10/15.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助已发布内容视图控制器
class LWHelpHaveIssueViewController: LWBaseViewController {

    // MARK: 列表视图
    /// 列表视图
    lazy var tableView : UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
//        view.mj_header  = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshDate))
//        view.mj_footer  = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreDate))
        view.mj_footer.isHidden = true
        return view
    }()
    /// 列表数组
    var cellArray = [LWHelpContentModel]()
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
// MARK: - 帮助已发布内容视图控制器
extension LWHelpHaveIssueViewController {
    /// 添加子控件
    //MARK: - 添加子控件
    func addViewSubviews() {
        view.addSubview(tableView)
    }
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        tableView.frame = self.view.bounds
    }

}
// =================================================================================================================================
// MARK: - 帮助已发布内容视图控制器UITableViewDelegateDataSource
extension LWHelpHaveIssueViewController :UITableViewDelegate, UITableViewDataSource {
    
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
    }
    
}
// =================================================================================================================================

// =================================================================================================================================
