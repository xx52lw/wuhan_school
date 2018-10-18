//
//  MerchantEvaluateDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantEvaluateDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    let bottomViewHeight = TABBAR_HEIGHT
    let toside = cmSizeFloat(20)
    let goodsEvaluateTitleToTextView = cmSizeFloat(15)
    let TEXT_COUNT_LIMIT = 100
    let selectedScore = #imageLiteral(resourceName: "orderEvaluateSelected")
    let unselectedScore = #imageLiteral(resourceName: "orderEvaluateUnselected")
    
    private  var topView:XYTopView!
    public var mainTabView:UITableView!
    private var tableHeaderView:UIView!
    public var evaluateModel:MerchantOrderEvaluateDetailModel!
    private var bottomView:UIView!
    private var shieldEvaluationBtn:UIButton!
    private var tableViewHeader:UIView!
    private var placeholderLabel:UILabel!
    
    private var  submitTotalAnswerBtn:UIButton!
    private var  commentTextView:UITextView!
    private var  goodsEvaluateTitleLabel:UILabel!
    private var goodsEvaluateTitleSeperateView:UIView!
    
     var service:MerchantOrderEvaluateDetailService = MerchantOrderEvaluateDetailService()
    
    //网络异常空白页
    public var orderEvaluateAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var orderEvaluateNoDataView:XYAbnormalViewManager!
    
    var commentId:String!
    
    //是否该条评论已屏蔽
    var ifShow:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createBottomView()
        service.merchantOrderEvaluateDataRequest(target: self, orderId: commentId)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "评价"
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
                self?.service.merchantOrderEvaluateDataRequest(target: self!, orderId: self!.commentId)
            }
        }
    }
    
    
    //MARK: - 创建Header
    func createTableviewHeader(){

        let starBtnWidth = cmSizeFloat(35)
        let starBtnHeight = cmSizeFloat(40)
        let textSpace = cmSizeFloat(8)
        
        tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: .leastNonzeroMagnitude))
        
        
        
        let starTipsLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(40)))
        starTipsLabel.font = cmSystemFontWithSize(15)
        starTipsLabel.textColor = MAIN_BLACK
        starTipsLabel.textAlignment = .center
        starTipsLabel.text = "商家评价"
        tableViewHeader.addSubview(starTipsLabel)
        
        tableViewHeader.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: starTipsLabel.bottom - cmSizeFloat(1)))
        
        
        let starToSide = (SCREEN_WIDTH - starBtnWidth*CGFloat(5))/2
        for index in 0..<5 {
            let starBtn = UIButton(frame: CGRect(x: starToSide + starBtnWidth*CGFloat(index), y: starTipsLabel.bottom, width: starBtnWidth, height: starBtnHeight))
            if index <= evaluateModel.merchantScore {
                starBtn.setImage(selectedScore, for: .normal)
            }else{
                starBtn.setImage(unselectedScore, for: .normal)
            }
            tableViewHeader.addSubview(starBtn)
        }
        
        
        
        let userCommentContentHeight = evaluateModel.CommentContent.stringHeight(SCREEN_WIDTH-toside*2, font: cmSystemFontWithSize(12))
        let userCommentContentLabel = UILabel(frame:CGRect(x: toside , y: starTipsLabel.frame.maxY + starBtnHeight, width: SCREEN_WIDTH-toside*2, height: userCommentContentHeight))
        userCommentContentLabel.text = evaluateModel.CommentContent
        userCommentContentLabel.font = cmSystemFontWithSize(12)
        userCommentContentLabel.textColor = MAIN_BLACK2
        userCommentContentLabel.numberOfLines = 0
        userCommentContentLabel.text = evaluateModel.CommentContent
        tableViewHeader.addSubview(userCommentContentLabel)
        
        
         commentTextView = UITextView(frame: CGRect(x: toside, y: userCommentContentLabel.frame.maxY + textSpace , width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(70)))
        commentTextView.font = UIFont.systemFont(ofSize: 12)
        commentTextView.textColor = MAIN_BLACK2
        commentTextView.returnKeyType = .done
        commentTextView.layer.borderColor = MAIN_GRAY.cgColor
        commentTextView.layer.borderWidth = CGFloat(1)
        commentTextView.backgroundColor = .white
        commentTextView.delegate = self
        tableViewHeader.addSubview(commentTextView)
        

        

        
        let placeholderText = "回复用户评论，2-100字以内"
        let placeholderStrWidth = placeholderText.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        placeholderLabel = UILabel(frame:CGRect(x: toside + cmSizeFloat(7), y: commentTextView.frame.origin.y + cmSizeFloat(7), width: placeholderStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        placeholderLabel.text = placeholderText
        placeholderLabel.font = cmSystemFontWithSize(12)
        placeholderLabel.textColor = MAIN_GRAY
        tableViewHeader.addSubview(placeholderLabel)
        
        

        
        
        let submitStr = "提  交"
        let submitBtnWidth = submitStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)) + cmSizeFloat(14)
         submitTotalAnswerBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH/2 - submitBtnWidth/2, y: commentTextView.bottom + textSpace, width: submitBtnWidth, height: cmSizeFloat(25)))
        submitTotalAnswerBtn.setTitle(submitStr, for: .normal)
        submitTotalAnswerBtn.setTitleColor(MAIN_BLACK, for: .normal)
        submitTotalAnswerBtn.titleLabel?.font = cmSystemFontWithSize(13)
        submitTotalAnswerBtn.clipsToBounds = true
        submitTotalAnswerBtn.layer.cornerRadius = CGFloat(3)
        submitTotalAnswerBtn.layer.borderColor = MAIN_BLACK.cgColor
        submitTotalAnswerBtn.layer.borderWidth = CGFloat(1)
        submitTotalAnswerBtn.addTarget(self, action: #selector(submitTotalAnswerBtnAct), for: .touchUpInside)
        tableViewHeader.addSubview(submitTotalAnswerBtn)
        
        
        
          goodsEvaluateTitleLabel = UILabel(frame: CGRect(x: toside, y: submitTotalAnswerBtn.bottom + goodsEvaluateTitleToTextView, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
        goodsEvaluateTitleLabel.font = cmSystemFontWithSize(15)
        goodsEvaluateTitleLabel.textColor = MAIN_BLACK
        goodsEvaluateTitleLabel.textAlignment = .left
        goodsEvaluateTitleLabel.text = "商品评价"
        tableViewHeader.addSubview(goodsEvaluateTitleLabel)
        
        goodsEvaluateTitleSeperateView = XYCommonViews.creatCommonSeperateLine(pointY: goodsEvaluateTitleLabel.bottom +  goodsEvaluateTitleToTextView - CGFloat(1))
        tableViewHeader.addSubview(goodsEvaluateTitleSeperateView)
        
        
        if evaluateModel.HasReplay == true {
            commentTextView.text = evaluateModel.ReplyContent
            commentTextView.isEditable = false
            placeholderLabel.isHidden = true
            self.submitTotalAnswerBtn.removeFromSuperview()
            self.goodsEvaluateTitleLabel.frame.origin.y = self.commentTextView.bottom + self.goodsEvaluateTitleToTextView
            self.goodsEvaluateTitleSeperateView.frame.origin.y = self.goodsEvaluateTitleLabel.bottom +  self.goodsEvaluateTitleToTextView - CGFloat(1)
            self.tableViewHeader.frame.size.height = self.goodsEvaluateTitleLabel.bottom +  self.goodsEvaluateTitleToTextView
        }else{
            tableViewHeader.frame.size.height = self.goodsEvaluateTitleLabel.bottom +  self.goodsEvaluateTitleToTextView
        }
        
        
        
    }
    
    
    //MARK: - 商家评价提交按钮响应
    @objc func submitTotalAnswerBtnAct(){
        
        if commentTextView.text!.trimmingCharacters(in: .whitespaces).count < 2 {
            cmShowHUDToWindow(message: "回复内容不能少于2个字符")
            return
        }
        

            submitTotalAnswerBtn.isEnabled = false
        
        service.answerMerchantCommentRequest(evaluateID: self.evaluateModel.MerchantCommentID, commentStr: commentTextView.text!, successAct: { [weak self] in
            
            DispatchQueue.main.async {
                self?.commentTextView.isEditable = false
                self?.submitTotalAnswerBtn.removeFromSuperview()
                self?.goodsEvaluateTitleLabel.frame.origin.y = self!.commentTextView.bottom + self!.goodsEvaluateTitleToTextView
                self?.goodsEvaluateTitleSeperateView.frame.origin.y = self!.goodsEvaluateTitleLabel.bottom +  self!.goodsEvaluateTitleToTextView - CGFloat(1)
                self?.tableViewHeader.frame.size.height = self!.goodsEvaluateTitleLabel.bottom +  self!.goodsEvaluateTitleToTextView
                self?.mainTabView.reloadData()
            }
        }) { [weak self] in
            self?.submitTotalAnswerBtn.isEnabled = true
        }
        
    }
    
    
    //MARK: - 创建bottomView
    func createBottomView() {
        
        bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = cmColorWithString(colorName: "565555")
        
        let tipsStr = "屏蔽后，用户评价将不显示"
        let tipsLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: tipsStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)), height: bottomViewHeight))
        tipsLabel.textColor = MAIN_WHITE
        tipsLabel.font = cmSystemFontWithSize(15)
        tipsLabel.textAlignment = .left
        tipsLabel.text = tipsStr
        bottomView.addSubview(tipsLabel)
        
        
        shieldEvaluationBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH*2/3, y: 0, width: SCREEN_WIDTH*1/3, height: bottomViewHeight))
        shieldEvaluationBtn.setTitleColor(.white, for: .normal)
        shieldEvaluationBtn.backgroundColor = cmColorWithString(colorName: "0ED390")
        shieldEvaluationBtn.setTitle("屏蔽评价", for: .normal)
        shieldEvaluationBtn.setTitleColor(.white, for: .normal)
        shieldEvaluationBtn.titleLabel?.font = cmBoldSystemFontWithSize(16)
        shieldEvaluationBtn.addTarget(self, action: #selector(shieldEvaluationBtnAct), for: .touchUpInside)
        bottomView.addSubview(shieldEvaluationBtn)
        if ifShow == false {
            shieldEvaluationBtn.setTitle("已屏蔽", for: .normal)
            shieldEvaluationBtn.isEnabled = false
        }
        self.view.addSubview(bottomView)
    }
    
    //MARK: - 屏蔽评价
    @objc func shieldEvaluationBtnAct() {
        
        shieldEvaluationBtn.isEnabled = false
        
        service.shieldEvaluationRequest(merchantEvaluateID: self.evaluateModel.MerchantCommentID, successAct: {
            cmShowHUDToWindow(message: "屏蔽成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                let navVCCount = self!.navigationController!.viewControllers.count
                if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? MerchantOrderEvaluateListVC {
                    lastVC.mainTabView.mj_header.beginRefreshing()
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        }) { [weak self] in
            self?.shieldEvaluationBtn.isEnabled = true
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
        mainTabView.register(MerchantOrderDetailEvaluateTabcell.self, forCellReuseIdentifier: "MerchantOrderDetailEvaluateTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return evaluateModel.GoodsEvaluateCellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight = CGFloat(0)
        
        if evaluateModel.GoodsEvaluateCellModelArr[indexPath.row].HasReplay == true {
            cellHeight = cmSizeFloat(15*2+40+70) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) + cmSizeFloat(8)
        }else{
            cellHeight = cmSizeFloat(15*2+40+70) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) + cmSizeFloat(25) +  cmSizeFloat(8*2)
        }
        
        
       let commentContentStrHeight = evaluateModel.GoodsEvaluateCellModelArr[indexPath.row].CommentContent.stringHeight(SCREEN_WIDTH-toside*2, font: cmSystemFontWithSize(12))
        return  cellHeight + commentContentStrHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOrderDetailEvaluateTabcell")
        if cell == nil {
            cell = MerchantOrderDetailEvaluateTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantOrderDetailEvaluateTabcell")
        }
        if let targetCell = cell as? MerchantOrderDetailEvaluateTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: evaluateModel.GoodsEvaluateCellModelArr[indexPath.row], indexRow: indexPath.row)
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
