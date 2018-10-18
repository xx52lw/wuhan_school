//
//  ApplyCustomServiceVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/31.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ApplyCustomServiceVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    private  var topView:XYTopView!
    private let toside = cmSizeFloat(20)
    private let subviewHeight = cmSizeFloat(50)
    private let reasonStrArr = ["订单已送达但未收到商品","商品质量问题","商品严重错送漏送","其他原因"]
    private let TEXT_COUNT_LIMIT = 150
    
    
    public var mainTabView:UITableView!
    var tableViewHeader:UIView!
    var tableViewFooter:UIView!
    var placeholderLabel:UILabel!
    var cancelReasonTextView:UITextView!
    
    var cancelOnlineModelArr:[OrderCancelOnlineModel] = Array()
    var selectedFlag:Int = -1
    var orderID:String!
    var service:OrderDetailService =  OrderDetailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        createData()
        creatNavTopView()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - cell数据创建
    func createData() {
        for index in 0..<reasonStrArr.count{
            let reasonModel = OrderCancelOnlineModel()
            reasonModel.cancelReasonStr = reasonStrArr[index]
            if index == reasonStrArr.count - 1 {
                reasonModel.cancelReasonTips = "请详细说明原因，便于商家了解情况，2-100字符"
            }
            cancelOnlineModelArr.append(reasonModel)
        }
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "申请客服介入"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建headerView
    func createTableviewHeader(){
        tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: subviewHeight))
        let titleLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height: subviewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "申请客服介入的原因"
        tableViewHeader.addSubview(titleLabel)
        
        tableViewHeader.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: subviewHeight - CGFloat(1)))
    }
    
    //MARK: - 创建footerView
    func createTableviewFooter(){
        let toFooterTop = cmSizeFloat(5)
        tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(5+125+20+40)))
        
        cancelReasonTextView = UITextView(frame: CGRect(x: toside, y: toFooterTop , width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(125)))
        cancelReasonTextView.font = UIFont.systemFont(ofSize: 12)
        cancelReasonTextView.textColor = MAIN_BLACK2
        cancelReasonTextView.returnKeyType = .done
        cancelReasonTextView.layer.borderColor = MAIN_GRAY.cgColor
        cancelReasonTextView.layer.borderWidth = CGFloat(1)
        cancelReasonTextView.backgroundColor = .white
        cancelReasonTextView.delegate = self
        tableViewFooter.addSubview(cancelReasonTextView)
        
        let placeholderText = "请输入申请客服介入原因，2-100字以内"
        let placeholderStrWidth = placeholderText.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        placeholderLabel = UILabel(frame:CGRect(x: toside + cmSizeFloat(7), y: cancelReasonTextView.frame.origin.y + cmSizeFloat(7), width: placeholderStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        placeholderLabel.text = placeholderText
        placeholderLabel.font = cmSystemFontWithSize(12)
        placeholderLabel.textColor = MAIN_GRAY
        tableViewFooter.addSubview(placeholderLabel)
        
        let submitAdressBtn = UIButton(frame: CGRect(x: toside, y: cancelReasonTextView.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        submitAdressBtn.setTitle("提 交", for: .normal)
        submitAdressBtn.setTitleColor(MAIN_WHITE, for: .normal)
        submitAdressBtn.titleLabel?.font = cmSystemFontWithSize(15)
        submitAdressBtn.layer.cornerRadius = cmSizeFloat(4)
        submitAdressBtn.clipsToBounds = true
        submitAdressBtn.backgroundColor = MAIN_GREEN
        submitAdressBtn.addTarget(self, action: #selector(submitBtnAct), for: .touchUpInside)
        tableViewFooter.addSubview(submitAdressBtn)
        
    }
    
    //MARK: - 提交按钮
    @objc func submitBtnAct(){
        
        var cancelReasonText:String!
        
        if selectedFlag == -1 {
            cmShowHUDToWindow(message: "清先选择申请客服介入原因")
            return
        }
        
        if selectedFlag == self.cancelOnlineModelArr.count - 1 {
            if cancelReasonTextView.text.trimmingCharacters(in: .whitespaces).count < 2 {
                cmShowHUDToWindow(message: "申请客服介入原因描述不能少于2个字符")
                return
            }
            cancelReasonText = cancelReasonTextView.text
        }else{
            cancelReasonText = self.cancelOnlineModelArr[selectedFlag].cancelReasonStr
        }
        
        service.applicationForServiceRequest(userOrderID: self.orderID, content: cancelReasonText, successAct: {
            cmShowHUDToWindow(message: "提交成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                let navVCCount = self!.navigationController!.viewControllers.count
                if  let targetVC = self?.navigationController?.viewControllers[navVCCount - 3] as? OrderManageVC {
                    targetVC.mainTabView.mj_header.beginRefreshing()
                    self?.navigationController?.popToViewController(targetVC, animated: true)
                }
            })
            
        }, failureAct: {
            
        })
        
        
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        createTableviewHeader()
        createTableviewFooter()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        mainTabView.tableHeaderView = tableViewHeader
        mainTabView.tableFooterView = tableViewFooter
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(ActCommonReasonTabCell.self, forCellReuseIdentifier: "ActCommonReasonTabCell")
        mainTabView.register(OtherReasonTabCell.self, forCellReuseIdentifier: "OtherReasonTabCell")
        
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cancelOnlineModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if cancelOnlineModelArr[indexPath.row].cancelReasonTips.isEmpty {
            return  ActCommonReasonTabCell.cellHeight
        }else{
            return  OtherReasonTabCell.cellHeight
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cancelOnlineModelArr[indexPath.row].cancelReasonTips.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ActCommonReasonTabCell")
            if cell == nil {
                cell = ActCommonReasonTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "ActCommonReasonTabCell")
            }
            if let targetCell = cell as? ActCommonReasonTabCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: cancelOnlineModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "OtherReasonTabCell")
            if cell == nil {
                cell = OtherReasonTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "OtherReasonTabCell")
            }
            if let targetCell = cell as? OtherReasonTabCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: cancelOnlineModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFlag = indexPath.row
        for index in 0..<self.cancelOnlineModelArr.count {
            if index == indexPath.row {
                self.cancelOnlineModelArr[index].isSelected = true
            }else{
                self.cancelOnlineModelArr[index].isSelected = false
            }
        }
        self.mainTabView.reloadData()
    }
    
    
    //MARK: - TextView delegate
    func textViewDidChange(_ textView: UITextView) {
        let contentStr = textView.text
        if textView.text.count >= TEXT_COUNT_LIMIT{
            textView.text = contentStr![0..<(TEXT_COUNT_LIMIT-1)]
            cmShowHUDToWindow(message:"最多输入100个字")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty{
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
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
