//
//  MerchantOrderDetailEvaluateTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderDetailEvaluateTabcell: UITableViewCell,UITextViewDelegate {
    
    
    let toSide = cmSizeFloat(20)
    let TEXT_COUNT_LIMIT = 100
    let selectedScore = #imageLiteral(resourceName: "orderEvaluateSelected")
    let unselectedScore = #imageLiteral(resourceName: "orderEvaluateUnselected")
    let starBtnWidth = cmSizeFloat(35)
    let starBtnHeight = cmSizeFloat(40)
    let textSpace = cmSizeFloat(8)
    let submitBtnHeight = cmSizeFloat(25)
    let toTopOrBottomHeight = cmSizeFloat(15)
    
    let submitStr = "提  交"
    let placeholderText = "回复用户评论，2-100字以内"
    
    var goodsNameLabel:UILabel!
    var userCommentContentLabel:UILabel!
    var submitAnswerBtn:UIButton!
    var answerTextView:UITextView!
    var evaluateScoreView:UIView!
    var placeholderLabel:UILabel!
    
    var currentIndex:Int!
    var seperateLine:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            goodsNameLabel = UILabel(frame: CGRect(x: toSide, y: toTopOrBottomHeight, width: SCREEN_WIDTH - toSide*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            goodsNameLabel.font = cmSystemFontWithSize(13)
            goodsNameLabel.textColor = MAIN_BLACK2
            goodsNameLabel.textAlignment = .left
            self.addSubview(goodsNameLabel)
            
            evaluateScoreView = UIView(frame: CGRect(x: toSide, y: goodsNameLabel.bottom, width: SCREEN_WIDTH - toSide*2, height: starBtnHeight))
            self.addSubview(evaluateScoreView)
            
            
            userCommentContentLabel = UILabel(frame: .zero)
            userCommentContentLabel.font = cmSystemFontWithSize(12)
            userCommentContentLabel.textColor = MAIN_BLACK2
            userCommentContentLabel.textAlignment = .left
            userCommentContentLabel.numberOfLines = 0
            self.addSubview(userCommentContentLabel)
            
            

            answerTextView = UITextView(frame: .zero)
            answerTextView.font = UIFont.systemFont(ofSize: 12)
            answerTextView.textColor = MAIN_BLACK2
            answerTextView.returnKeyType = .done
            answerTextView.layer.borderColor = MAIN_GRAY.cgColor
            answerTextView.layer.borderWidth = CGFloat(1)
            answerTextView.backgroundColor = .white
            answerTextView.delegate = self
            self.addSubview(answerTextView)
            

            placeholderLabel = UILabel(frame:.zero)
            placeholderLabel.text = placeholderText
            placeholderLabel.font = cmSystemFontWithSize(12)
            placeholderLabel.textColor = MAIN_GRAY
            self.addSubview(placeholderLabel)
            
            
            submitAnswerBtn = UIButton(frame: .zero)
            submitAnswerBtn.setTitle(submitStr, for: .normal)
            submitAnswerBtn.setTitleColor(MAIN_BLACK, for: .normal)
            submitAnswerBtn.titleLabel?.font = cmSystemFontWithSize(13)
            submitAnswerBtn.clipsToBounds = true
            submitAnswerBtn.layer.cornerRadius = CGFloat(3)
            submitAnswerBtn.layer.borderColor = MAIN_BLACK.cgColor
            submitAnswerBtn.layer.borderWidth = CGFloat(1)
            submitAnswerBtn.addTarget(self, action: #selector(submitAnswerBtnAct), for: .touchUpInside)
            self.addSubview(submitAnswerBtn)
            
            seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: 0)
            self.addSubview(seperateLine)
        }
        
    }
    
    //MARK: - 提交商品评价按钮
    @objc func submitAnswerBtnAct(){
        
        if answerTextView.text!.trimmingCharacters(in: .whitespaces).count < 2 {
            cmShowHUDToWindow(message: "回复内容不能少于2个字符")
            return
        }
        
        if let currentVC = GetCurrentViewController() as? MerchantEvaluateDetailVC {
            submitAnswerBtn.isEnabled = false
            currentVC.service.answerGoodsCommentRequest(evaluateID: currentVC.evaluateModel.GoodsEvaluateCellModelArr[currentIndex].GoodsCommentID, commentStr: answerTextView.text!, successAct: { [weak self] in
                currentVC.evaluateModel.GoodsEvaluateCellModelArr[self!.currentIndex].HasReplay = true
                currentVC.evaluateModel.GoodsEvaluateCellModelArr[self!.currentIndex].ReplyContent = self!.answerTextView.text
                DispatchQueue.main.async {
                    self?.refreshCellUI()
                }
            }, failureAct: { [weak self] in
                self?.submitAnswerBtn.isEnabled = true
            })
            
            
        }
        
        
    }
    
    //MARK: - 设置Model
    func setModel(model:MerchantGoodsEvaluateCellModel,indexRow:Int){
        
        currentIndex = indexRow
        
        let commentContentStrHeight = model.CommentContent.stringHeight(SCREEN_WIDTH-toSide*2, font: cmSystemFontWithSize(12))
        userCommentContentLabel.frame = CGRect(x: toSide, y: evaluateScoreView.bottom, width: SCREEN_WIDTH-toSide*2, height: commentContentStrHeight)
        userCommentContentLabel.text = model.CommentContent
        
        
        
        answerTextView.frame = CGRect(x: toSide, y: userCommentContentLabel.frame.maxY + textSpace, width: SCREEN_WIDTH-toSide*2, height: cmSizeFloat(70))
        answerTextView.text = model.ReplyContent
        
        let placeholderStrWidth = placeholderText.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        placeholderLabel.frame = CGRect(x: toSide + cmSizeFloat(7), y: answerTextView.frame.origin.y + cmSizeFloat(7), width: placeholderStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)))
        
        if model.HasReplay == false {
            let submitBtnWidth = submitStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)) + cmSizeFloat(14)
            submitAnswerBtn.frame =   CGRect(x: SCREEN_WIDTH/2 - submitBtnWidth/2, y: answerTextView.bottom + textSpace, width: submitBtnWidth, height: submitBtnHeight)
            seperateLine.frame.origin.y = submitAnswerBtn.bottom + toTopOrBottomHeight - cmSizeFloat(1)
             placeholderLabel.isHidden = false
            answerTextView.isEditable = true
        }else{
            submitAnswerBtn.removeFromSuperview()
            seperateLine.frame.origin.y = answerTextView.bottom + toTopOrBottomHeight - cmSizeFloat(1)
            placeholderLabel.isHidden = true
            answerTextView.isEditable = false
        }
        
        
        goodsNameLabel.text = model.GoodsName
        if answerTextView.text.isEmpty{
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
        
        
        
        //删除子view
        if evaluateScoreView.subviews.count > 0 {
            for subview in evaluateScoreView.subviews {
                subview.removeFromSuperview()
            }
        }
        //重新加载子View
        for index in 0..<5 {
            let starBtn = UIButton(frame: CGRect(x: starBtnWidth*CGFloat(index), y: 0, width: starBtnWidth, height: starBtnHeight))
            if index <= model.StarNum {
                starBtn.setImage(selectedScore, for: .normal)
            }else{
                starBtn.setImage(unselectedScore, for: .normal)
            }
            evaluateScoreView.addSubview(starBtn)
        }
        
    }
    

    //MARK: - 刷新cell布局
    func refreshCellUI(){
        

        
        if let currentVC = GetCurrentViewController() as? MerchantEvaluateDetailVC {
            currentVC.mainTabView.reloadData()
        }
        
    }
    
    
    //MARK: - TextView delegate
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    
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
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty{
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
        
        if let cuurentVC = GetCurrentViewController() as? OrderEvaluateVC {
            cuurentVC.evaluateModel.waitEvaluateGoodsModelArr[currentIndex].evaluateContent = textView.text
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
