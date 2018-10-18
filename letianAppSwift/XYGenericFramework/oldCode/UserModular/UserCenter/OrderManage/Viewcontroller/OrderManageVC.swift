//
//  OrderManageVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class OrderManageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {



    
    var topView:XYTopView!
    var segmentBtnsView:UIView!
    var segmentChooseLine:UIView!
    
    var mainTabView:UITableView!
    
    var isOrderListHomePage = false
    
    var segmentsBtnArr:[UIButton] = Array()
    
    var orderManageModel:OrderManageModel!
    var cuurentSelectedTypeTag:Int = 0
    
    var requestTypeModelArr:[OrderManageRequstTypeModel] = Array()
    var service:OrderManageListService =  OrderManageListService()
    
    var detailOrderService:OrderDetailService =  OrderDetailService()
    //网络异常空白页
    public var orderManagerAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var orderManagerNoDataView:XYAbnormalViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        createRequstTypeModelArr()
        creatNavTopView()
        creatSegmentBtn()
        service.orderManagerListDataRequest(target: self, requestTypeModel: requestTypeModelArr[0])
        // Do any additional setup after loading the view.
    }

    
    func createRequstTypeModelArr() {
        let requestUrlArr = [allOrdersListUrl,waitPayListUrl,waitRecieveGoodsUrl,waiteEvaluateUrl,refundListUrl]
        let requestTypeArr = [orderRequestTypeEnum.allOrders,orderRequestTypeEnum.waitPay,orderRequestTypeEnum.waitRecieve,orderRequestTypeEnum.waiteEvaluate,orderRequestTypeEnum.refund]
        let segmentBtnStrArr = ["全部","待支付","待收货","待评价","退单记录"]

        
        for index in 0..<segmentBtnStrArr.count {
            let typeModel = OrderManageRequstTypeModel()
            typeModel.requestType = requestTypeArr[index]
            typeModel.requestTypeUrl = requestUrlArr[index]
            typeModel.typeName = segmentBtnStrArr[index]
            requestTypeModelArr.append(typeModel)
        }
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        if isOrderListHomePage == false {
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "我的订单"
        }else {
            self.view.addSubview(topView.navigationTitleItem())
            topView.titleLabel.text = "订单"
        }
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? (isOrderListHomePage ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT-TABBAR_HEIGHT:SCREEN_HEIGHT-STATUS_NAV_HEIGHT):self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            orderManagerNoDataView = abnormalView
            orderManagerNoDataView.abnormalType = .noData
        }else if isNetError == true{
            orderManagerAbnormalView = abnormalView
            orderManagerAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            orderManagerAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.orderManagerListDataRequest(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
            }
        }
    }
    
    
    //MARK: - 创建分段按钮
    func creatSegmentBtn(){
        let segmentBtnsViewHeight = cmSizeFloat(40)
        segmentBtnsView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height:segmentBtnsViewHeight + cmSizeFloat(10) ))
        for index in 0..<requestTypeModelArr.count {
            
            let segmentBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count)*CGFloat(index), y: 0, width: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count), height: segmentBtnsViewHeight))
            segmentBtn.setTitle(requestTypeModelArr[index].typeName, for: .normal)
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
            if index == 0{
                segmentBtn.setTitleColor(MAIN_BLUE, for: .normal)
            }
            segmentBtn.titleLabel?.font = cmSystemFontWithSize(15)
            segmentBtn.tag = 200 + index
            segmentBtn.addTarget(self, action: #selector(segmentAct(sender:)), for: .touchUpInside)
            segmentsBtnArr.append(segmentBtn)
            segmentBtnsView.addSubview(segmentBtn)
            
            
        }
        
        segmentChooseLine = UIView(frame: CGRect(x: 0, y: segmentBtnsViewHeight + cmSizeFloat(10) - cmSizeFloat(9), width: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count), height: cmSizeFloat(2)))
        segmentChooseLine.backgroundColor = MAIN_BLUE
        segmentBtnsView.addSubview(segmentChooseLine)
        
        let segementSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: segmentBtnsViewHeight + cmSizeFloat(10) - cmSizeFloat(7), lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        segmentBtnsView.addSubview(segementSeperateLine)

        self.view.addSubview(segmentBtnsView)

    }
    //MARK: - 分段按钮响应
    @objc func segmentAct(sender:UIButton){
        for segmentBtn in segmentsBtnArr {
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
        }
        sender.setTitleColor(MAIN_BLUE, for: .normal)
        segmentChooseLine.frame.origin.x = SCREEN_WIDTH/CGFloat(requestTypeModelArr.count)*CGFloat(sender.tag - 200)
        
        //如果点击同一个btn，不做数据请求处理
        if cuurentSelectedTypeTag == sender.tag - 200{
            return
        }
        
        cuurentSelectedTypeTag = sender.tag - 200
        self.service.orderManagerListDataRequest(target: self, requestTypeModel: self.requestTypeModelArr[cuurentSelectedTypeTag])

    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:segmentBtnsView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsView.bottom), style: .plain)
        if isOrderListHomePage == true {
          mainTabView.frame.size.height = SCREEN_HEIGHT - segmentBtnsView.bottom - TABBAR_HEIGHT
        }
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
            self?.service.refreshOrderManagerListData(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
            if self?.mainTabView.mj_footer != nil {
                self?.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [weak self] in
            self?.service.orderManagerListPullData(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
        })
        
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(OrderManageCell.self, forCellReuseIdentifier: "OrderManageCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderManageModel.allOrderCellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

            return  OrderManageCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            var cell = tableView.dequeueReusableCell(withIdentifier: "OrderManageCell")
            if cell == nil {
                cell = OrderManageCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderManageCell")
            }
            if let targetCell = cell as? OrderManageCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: orderManageModel.allOrderCellModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //查看订单
            if  orderManageModel.allOrderCellModelArr[indexPath.row].CanPay == true {
                self.detailOrderService.waitPayOrderDetailDataRequest(userOrderID: orderManageModel.allOrderCellModelArr[indexPath.row].UserOrderID)
            }else{
                self.detailOrderService.otherOrderDetailDataRequest(userOrderID: orderManageModel.allOrderCellModelArr[indexPath.row].UserOrderID)
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        if isOrderListHomePage == false {
            tabBarController?.tabBar.isHidden = true
        }else{
            tabBarController?.tabBar.isHidden = false
        }
        if  mainTabView != nil {
            mainTabView.mj_header.beginRefreshing()
        }
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
