//
//  OrderEvaluateVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/30.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderEvaluateVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    let bottomViewHeight = TABBAR_HEIGHT
    let toside = cmSizeFloat(20)
    let TEXT_COUNT_LIMIT = 150
    let selectedScore = #imageLiteral(resourceName: "orderEvaluateSelected")
    let unselectedScore = #imageLiteral(resourceName: "orderEvaluateUnselected")
    
  private  var topView:XYTopView!
   public var mainTabView:UITableView!
   private var tableHeaderView:UIView!
    public var evaluateModel:OrderEvaluateModel!
   private var bottomView:UIView!
   private var submitBtn:UIButton!
   private var tableViewHeader:UIView!
   private var placeholderLabel:UILabel!
   private var starBtnArr:[UIButton] = Array()
    private var service:OrderEvaluateService = OrderEvaluateService()

    //网络异常空白页
    public var orderEvaluateAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var orderEvaluateNoDataView:XYAbnormalViewManager!
    
    var orderId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createBottomView()
        service.orderWaitEvaluateDataRequest(target: self, orderId: orderId)
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "订单评价"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            orderEvaluateNoDataView = abnormalView
            orderEvaluateNoDataView.abnormalType = .noData
        }else if isNetError == true{
            orderEvaluateAbnormalView = abnormalView
            orderEvaluateAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            orderEvaluateAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.orderWaitEvaluateDataRequest(target: self!, orderId: self!.orderId)
            }
        }
    }
    
    
    //MARK: - 创建Header
    func createTableviewHeader(){
        let toTop = cmSizeFloat(15)
        let starTipsToSellerNameHeight = cmSizeFloat(7)
        let goodsEvaluateTitleToTextView = cmSizeFloat(15)
        let starBtnWidth = cmSizeFloat(35)
        let starBtnHeight = cmSizeFloat(40)
        
        let tableViewHeaderHeight = cmSizeFloat(15+7+40+70+15+15) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(16)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))
        tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableViewHeaderHeight))
        
        let sellerNameLabel = UILabel(frame: CGRect(x: toside, y: toTop, width: SCREEN_WIDTH-toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))))
        sellerNameLabel.font = cmSystemFontWithSize(16)
        sellerNameLabel.textColor = MAIN_BLACK
        sellerNameLabel.textAlignment = .center
        sellerNameLabel.text = evaluateModel.MerchantName
        tableViewHeader.addSubview(sellerNameLabel)
        
        
        let starTipsLabel = UILabel(frame: CGRect(x: toside, y: sellerNameLabel.bottom + starTipsToSellerNameHeight, width: SCREEN_WIDTH-toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
        starTipsLabel.font = cmSystemFontWithSize(14)
        starTipsLabel.textColor = MAIN_BLACK
        starTipsLabel.textAlignment = .center
        starTipsLabel.text = "商家综合评价"
        tableViewHeader.addSubview(starTipsLabel)
        
        let starToSide = (SCREEN_WIDTH - starBtnWidth*CGFloat(5))/2
        for index in 0..<5 {
            let starBtn = UIButton(frame: CGRect(x: starToSide + starBtnWidth*CGFloat(index), y: starTipsLabel.bottom, width: starBtnWidth, height: starBtnHeight))
            if index <= evaluateModel.merchantScore {
                starBtn.setImage(selectedScore, for: .normal)
            }else{
                starBtn.setImage(unselectedScore, for: .normal)
            }
            starBtn.tag = 300 + index
            starBtn.addTarget(self, action: #selector(selectedStarAct(sender:)), for: .touchUpInside)
            starBtnArr.append(starBtn)
            tableViewHeader.addSubview(starBtn)
        }
        
        
       let commentTextView = UITextView(frame: CGRect(x: toside, y: starTipsLabel.frame.maxY + starBtnHeight , width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(70)))
        commentTextView.font = UIFont.systemFont(ofSize: 12)
        commentTextView.textColor = MAIN_BLACK2
        commentTextView.returnKeyType = .done
        commentTextView.layer.borderColor = MAIN_GRAY.cgColor
        commentTextView.layer.borderWidth = CGFloat(1)
        commentTextView.backgroundColor = .white
        commentTextView.delegate = self
        tableViewHeader.addSubview(commentTextView)
        
        let placeholderText = "说说哪里不满意，帮助商家改进，2-150字以内"
        let placeholderStrWidth = placeholderText.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        placeholderLabel = UILabel(frame:CGRect(x: toside + cmSizeFloat(7), y: commentTextView.frame.origin.y + cmSizeFloat(7), width: placeholderStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        placeholderLabel.text = placeholderText
        placeholderLabel.font = cmSystemFontWithSize(12)
        placeholderLabel.textColor = MAIN_GRAY
        tableViewHeader.addSubview(placeholderLabel)
        
        
        let  goodsEvaluateTitleLabel = UILabel(frame: CGRect(x: toside, y: commentTextView.bottom + goodsEvaluateTitleToTextView, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
        goodsEvaluateTitleLabel.font = cmSystemFontWithSize(15)
        goodsEvaluateTitleLabel.textColor = MAIN_BLACK
        goodsEvaluateTitleLabel.textAlignment = .left
        goodsEvaluateTitleLabel.text = "商品评价"
        tableViewHeader.addSubview(goodsEvaluateTitleLabel)
        
        
        tableViewHeader.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: tableViewHeaderHeight - CGFloat(1)))
    }
    
    
    //MARK: - 创建bottomView
    func createBottomView() {
        
        bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = cmColorWithString(colorName: "565555")
        
        let tipsStr = "评价后获得商家积分"
        let tipsLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: tipsStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)), height: bottomViewHeight))
        tipsLabel.textColor = MAIN_WHITE
        tipsLabel.font = cmSystemFontWithSize(15)
        tipsLabel.textAlignment = .left
        tipsLabel.text = tipsStr
        bottomView.addSubview(tipsLabel)
        
        
        submitBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH*2/3, y: 0, width: SCREEN_WIDTH*1/3, height: bottomViewHeight))
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = cmColorWithString(colorName: "0ED390")
        submitBtn.setTitle("提交评价", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = cmBoldSystemFontWithSize(16)
        submitBtn.addTarget(self, action: #selector(submitBtnAct), for: .touchUpInside)
        bottomView.addSubview(submitBtn)
        
        self.view.addSubview(bottomView)
    }
    
    //MARK: - 提交评价
    @objc func submitBtnAct() {
        submitBtn.isEnabled = false
        service.orderEvaluateSubmitRequest(orderEvaluateModel: self.evaluateModel, successAct: {
            cmShowHUDToWindow(message: "评价成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                self?.submitBtn.isEnabled = true
                self?.navigationController?.popViewController(animated: true)
            })
        }) {
            DispatchQueue.main.async { [weak self] in
                self?.submitBtn.isEnabled = true
            }
        }
        
    }
    
    
    //MARK: - 商家评分选择
    @objc func selectedStarAct(sender:UIButton) {
        self.evaluateModel.merchantScore = sender.tag - 300
        for starBtnIndex in 0..<self.starBtnArr.count {
            if starBtnIndex <= self.evaluateModel.merchantScore {
                self.starBtnArr[starBtnIndex].setImage(selectedScore, for: .normal)
            }else{
                self.starBtnArr[starBtnIndex].setImage(unselectedScore, for: .normal)
            }
        }
        
        
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        createTableviewHeader()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom - bottomViewHeight), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }

        mainTabView.tableHeaderView = tableViewHeader
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(WaitEvaluateTabcell.self, forCellReuseIdentifier: "WaitEvaluateTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return evaluateModel.waitEvaluateGoodsModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  WaitEvaluateTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "WaitEvaluateTabcell")
        if cell == nil {
            cell = WaitEvaluateTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "WaitEvaluateTabcell")
        }
        if let targetCell = cell as? WaitEvaluateTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: evaluateModel.waitEvaluateGoodsModelArr[indexPath.row], indexRow: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    //MARK: - TextView delegate
    func textViewDidChange(_ textView: UITextView) {
        let contentStr = textView.text
        if textView.text.count >= TEXT_COUNT_LIMIT{
            textView.text = contentStr![0..<(TEXT_COUNT_LIMIT-1)]
            cmShowHUDToWindow(message:"最多输入150个字")
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
        
      self.evaluateModel.merchantEvaluateContent = textView.text
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
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
