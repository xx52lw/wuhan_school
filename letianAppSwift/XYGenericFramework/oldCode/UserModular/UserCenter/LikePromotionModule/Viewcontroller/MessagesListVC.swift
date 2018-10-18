//
//  MessagesListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MessagesListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private  var topView:XYTopView!
    public var mainTabView:UITableView!
    
    //网络异常空白页
    public var messageListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var messageListNoDataView:XYAbnormalViewManager!
    
    var messageListModel:MessageListModel!
    var service:MessageListService = MessageListService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        self.service.getMessageListRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "消息"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            messageListNoDataView = abnormalView
            messageListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            messageListAbnormalView = abnormalView
            messageListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            messageListAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.getMessageListRequest(target: self!)
            }
        }
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(MessageListTabCell.self, forCellReuseIdentifier: "MessageListTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageListModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let contentInfoHeight = messageListModel.cellModelArr[indexPath.row].ContentInf.stringHeight(SCREEN_WIDTH - cmSizeFloat(20*2), font: cmSystemFontWithSize(14))
        let cellHeight = cmSizeFloat(30+7+7+40) + cmSingleLineHeight(fontSize:cmSystemFontWithSize(15))  + contentInfoHeight
        return  cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTabCell")
        if cell == nil {
            cell = MessageListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MessageListTabCell")
        }
        if let targetCell = cell as? MessageListTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: messageListModel.cellModelArr[indexPath.row])
            if indexPath.row == messageListModel.cellModelArr.count - 1 && messageListModel.cellModelArr.count > 1{
                targetCell.seperateView.isHidden = true
            }else{
                targetCell.seperateView.isHidden = false
            }
            return targetCell
        }else{
            return cell!
        }
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
