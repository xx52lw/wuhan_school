//
//  EvaluateView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/19.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class EvaluateView: UIView,UITableViewDelegate,UITableViewDataSource{

    typealias  MJFooterAct = ()->Void
    
    let toside = cmSizeFloat(10)
    let tableViewHeaderHeight = cmSizeFloat(120)
    let sectionHeaderHeight = cmSizeFloat(60)
    let seperateViewHeight = cmSizeFloat(7)
    let wordSpaceHeight = cmSizeFloat(5)
    let gradeViewHeight = cmSizeFloat(24)
    let unselectStar = #imageLiteral(resourceName: "evaluateStar")
    let selectedStar = #imageLiteral(resourceName: "evaluateSelectedStar")
    
    var evaluateTableView:UITableView!
    var tableViewHeader:UIView!
    var sectionHeader:UIView!
    var gradeLabel:UILabel!
    
    var canScroll:Bool = false

    
    var evaluateModel:EvaluateModel!
    
    var mjfooterAct:MJFooterAct!
    
    init(frame: CGRect,model:EvaluateModel) {
        super.init(frame: frame)
        evaluateModel = model
        
        creatTableView(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Go_Top"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Leave_Top"), object: nil)
    }
    
    
    //MARK: - 监听通知
    @objc  func acceptMsg(notification:Notification) {
        let notificationName = notification.name
        if notificationName.rawValue == "Home_Go_Top"  {
            let userInfo = notification.userInfo
            let canscroll = userInfo!["canScroll"] as! String
            if canscroll == "1" {
                self.canScroll = true
                
            }
        }else if notificationName.rawValue == "Home_Leave_Top"  {
            self.evaluateTableView.contentOffset = CGPoint.zero
            self.canScroll = false;
        }
    }
    
    func creatTableView(frame: CGRect){

        
        creatTableViewHeader(frameWidth:frame.size.width)
        creatSectionHeader()
        
        evaluateTableView = UITableView(frame: CGRect(x:frame.origin.x ,y:frame.origin.y, width:frame.size.width, height:frame.size.height ), style: .grouped)
        if #available(iOS 11, *) {
            evaluateTableView.contentInsetAdjustmentBehavior = .never
            evaluateTableView.estimatedRowHeight = 0
        }
        
        evaluateTableView.showsVerticalScrollIndicator = false
        evaluateTableView.showsHorizontalScrollIndicator = false
        evaluateTableView.tableHeaderView = tableViewHeader
        
        evaluateTableView.separatorStyle = .none
        evaluateTableView.register(EvaluateNoAnswerTabCell.self, forCellReuseIdentifier: "EvaluateNoAnswerTabCell")
        evaluateTableView.register(EvaluateAnswerTabCell.self, forCellReuseIdentifier: "EvaluateAnswerTabCell")
        
        evaluateTableView.mj_footer = XYRefreshFooter(refreshingBlock: { [weak self] in
            
            if self?.mjfooterAct != nil {
                self?.mjfooterAct()
            }
            
        })

        evaluateTableView.delegate = self
        evaluateTableView.dataSource = self
        
        //return evaluateTableView
    }
    
    func creatTableViewHeader(frameWidth:CGFloat){
        let scoresDicArr:[Dictionary<String,Double>] = [["商家评价: ":evaluateModel.sellerScore],["商品评价: ":evaluateModel.goodsScore],["配送速度: ":evaluateModel.deliveryScore]]
        tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableViewHeaderHeight))
        tableViewHeader.backgroundColor = .white
        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: 0)
        seperateLine.height = seperateViewHeight
        tableViewHeader.addSubview(seperateLine)
        
        let seperateBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: tableViewHeaderHeight - seperateViewHeight)
        seperateBottomLine.height = seperateViewHeight
        tableViewHeader.addSubview(seperateBottomLine)
        
        let commonScoreLabelToTop = (tableViewHeaderHeight - seperateViewHeight*2 - cmSingleLineHeight(fontSize:cmSystemFontWithSize(20)) - cmSingleLineHeight(fontSize:cmSystemFontWithSize(14)) - wordSpaceHeight)/2
        
        
        let commonScoreLabel = UILabel(frame: CGRect(x: 0, y:seperateLine.bottom + commonScoreLabelToTop, width: frameWidth/3, height: cmSingleLineHeight(fontSize:cmSystemFontWithSize(20))))
        commonScoreLabel.font = cmSystemFontWithSize(20)
        commonScoreLabel.textColor = MAIN_RED
        commonScoreLabel.textAlignment = .center
        commonScoreLabel.text =    String(evaluateModel.comprehensiveScore) + "分"
        tableViewHeader.addSubview(commonScoreLabel)
        
        let commonNameLabel = UILabel(frame: CGRect(x: 0, y: commonScoreLabel.bottom + wordSpaceHeight, width: frameWidth/3, height: cmSingleLineHeight(fontSize:cmSystemFontWithSize(14))))
        commonNameLabel.font = cmSystemFontWithSize(14)
        commonNameLabel.textColor = MAIN_GRAY
        commonNameLabel.textAlignment = .center
        commonNameLabel.text =   "综合评分"
        tableViewHeader.addSubview(commonNameLabel)
        
        
        let verticalSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: seperateLine.bottom + cmSizeFloat(16), lineWidth: cmSizeFloat(1.5), lineHeight: tableViewHeaderHeight - (cmSizeFloat(16) + seperateViewHeight)*2)
        verticalSeperateLine.frame.origin.x = frameWidth/3 - cmSizeFloat(1.5)
        tableViewHeader.addSubview(verticalSeperateLine)
        
        //评分布局
        for gradeDicIndex in 0..<scoresDicArr.count {
        let gradeViewToTop = (tableViewHeaderHeight - wordSpaceHeight*2 - gradeViewHeight*3)/2
        let gradeView = UIView(frame: CGRect(x: frameWidth/3 + cmSizeFloat(15), y: gradeViewToTop + (wordSpaceHeight+gradeViewHeight)*CGFloat(gradeDicIndex), width: frameWidth*2/3, height: gradeViewHeight))
        //gradeView.backgroundColor = cmColorWithString(colorName: "123456")
        
        let nameWidth = scoresDicArr[gradeDicIndex].keys.first!.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        let gradeNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: nameWidth, height:gradeViewHeight))
        gradeNameLabel.font = cmSystemFontWithSize(13)
        gradeNameLabel.textColor = MAIN_BLACK
        gradeNameLabel.textAlignment = .left
        gradeNameLabel.text =   scoresDicArr[gradeDicIndex].keys.first!
        gradeView.addSubview(gradeNameLabel)
        
        for index in 0..<5{
            let imageView = UIImageView(frame: CGRect(x: gradeNameLabel.right + selectedStar.size.width * CGFloat(index), y: gradeViewHeight/2 - selectedStar.size.height/2, width: selectedStar.size.width, height: selectedStar.size.height))
            if index < Int(scoresDicArr[gradeDicIndex].values.first!) {
                imageView.image = selectedStar
            }else{
                imageView.image = unselectStar
            }
            
            gradeView.addSubview(imageView)
            
            if index == 4 {
                gradeLabel = UILabel(frame: CGRect(x:imageView.frame.maxX + cmSizeFloat(4), y: 0, width: SCREEN_WIDTH - imageView.frame.maxX - cmSizeFloat(4) - toside, height: gradeViewHeight))
                gradeLabel.font = cmSystemFontWithSize(13)
                gradeLabel.textColor = MAIN_RED
                gradeLabel.textAlignment = .left
                gradeLabel.text = String(scoresDicArr[gradeDicIndex].values.first!) + "分"
                gradeView.addSubview(gradeLabel)
            }
        }
            tableViewHeader.addSubview(gradeView)
        }

        
        
        
        
        
        //tableViewHeader.backgroundColor = cmColorWithString(colorName: "123456")
    }
    
    
    func creatSectionHeader(){
        let sectionDicArr:[Dictionary<String,Int>] = [["全部":evaluateModel.totalCount],["满意":evaluateModel.satisfiedCount],["一般":evaluateModel.commonCount],["不满意":evaluateModel.dissatisfiedCount]]
        sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeaderHeight))
        sectionHeader.backgroundColor = .white
        
        for index in 0..<sectionDicArr.count {
            let btnWidth = SCREEN_WIDTH/CGFloat(sectionDicArr.count)
            let titleToTop = (sectionHeaderHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) - cmSizeFloat(5))/2
            let btnView = UIView(frame: CGRect(x: CGFloat(index)*btnWidth, y: 0, width: btnWidth, height: sectionHeaderHeight))
            let titleLabel = UILabel(frame: CGRect(x: 0, y: titleToTop, width: btnWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .center
            titleLabel.text = String(sectionDicArr[index].keys.first!)
            btnView.addSubview(titleLabel)
            
            let evaluateCountLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.bottom + cmSizeFloat(5), width: btnWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            evaluateCountLabel.font = cmSystemFontWithSize(13)
            evaluateCountLabel.textColor = MAIN_GRAY
            evaluateCountLabel.textAlignment = .center
            evaluateCountLabel.text = String(sectionDicArr[index].values.first!)
            btnView.addSubview(evaluateCountLabel)
            
            sectionHeader.addSubview(btnView)
            
        }
        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: sectionHeaderHeight - cmSizeFloat(1))
        sectionHeader.addSubview(seperateLine)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluateModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if evaluateModel.cellModelArr[indexPath.row].answerContent.isEmpty {
            let commentContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10+8*2)
            let evaluateCellHeight = evaluateModel.cellModelArr[indexPath.row].evaluateContent.stringHeight(commentContentWidth, font: cmSystemFontWithSize(13)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + cmSizeFloat(20+24+10+1)
            return evaluateCellHeight
        }else{
            //评论高度
            let commentContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10*2+8)
            let commentContentHeight = evaluateModel.cellModelArr[indexPath.row].evaluateContent.stringHeight(commentContentWidth, font: cmSystemFontWithSize(13))
            //回复高度
            let answerContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10*2+8+4)
            let answerContentHeight = evaluateModel.cellModelArr[indexPath.row].answerContent.stringHeight(answerContentWidth, font: cmSystemFontWithSize(13))
            let otherHeight = cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + cmSizeFloat(20+24+15+7)
            let evaluateCellHeight = answerContentHeight + otherHeight + commentContentHeight
            return evaluateCellHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if evaluateModel.cellModelArr[indexPath.row].answerContent.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateNoAnswerTabCell")
            if cell == nil {
                cell = EvaluateNoAnswerTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "EvaluateNoAnswerTabCell")
            }
            if let targetCell = cell as? EvaluateNoAnswerTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: evaluateModel.cellModelArr[indexPath.row])
                
                
                return targetCell
            }else{
                return cell!
            }
        }else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateAnswerTabCell")
            if cell == nil {
                cell = EvaluateAnswerTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "EvaluateAnswerTabCell")
            }
            if let targetCell = cell as? EvaluateAnswerTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: evaluateModel.cellModelArr[indexPath.row])
                
                
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeader
    }
    
    
    
    
    //MARK: - Scrollview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.canScroll == false {
            scrollView.contentOffset = .zero
        }
        
        let offsetY = scrollView.contentOffset.y
        if (offsetY < 0) {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Home_Leave_Top") , object: nil, userInfo: ["canScroll":"1"])
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
