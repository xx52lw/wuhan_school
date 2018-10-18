//
//  WaitEvaluateTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/30.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class WaitEvaluateTabcell: UITableViewCell,UITextViewDelegate  {

    
    static var cellHeight = cmSizeFloat(15+40+70+15) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))
    let toSide = cmSizeFloat(20)
    let TEXT_COUNT_LIMIT = 100
    let selectedScore = #imageLiteral(resourceName: "orderEvaluateSelected")
    let unselectedScore = #imageLiteral(resourceName: "orderEvaluateUnselected")
    let starBtnWidth = cmSizeFloat(35)
    let starBtnHeight = cmSizeFloat(40)
    
    var goodsNameLabel:UILabel!
    var commentTextView:UITextView!
    var evaluateScoreView:UIView!
    var placeholderLabel:UILabel!

    var currentIndex:Int!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            goodsNameLabel = UILabel(frame: CGRect(x: toSide, y: cmSizeFloat(15), width: SCREEN_WIDTH - toSide*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            goodsNameLabel.font = cmSystemFontWithSize(13)
            goodsNameLabel.textColor = MAIN_BLACK2
            goodsNameLabel.textAlignment = .left
            self.addSubview(goodsNameLabel)
            
            evaluateScoreView = UIView(frame: CGRect(x: toSide, y: goodsNameLabel.bottom, width: SCREEN_WIDTH - toSide*2, height: starBtnHeight))
            self.addSubview(evaluateScoreView)
            
            commentTextView = UITextView(frame: CGRect(x: toSide, y: evaluateScoreView.frame.maxY, width: SCREEN_WIDTH-toSide*2, height: cmSizeFloat(70)))
            commentTextView.font = UIFont.systemFont(ofSize: 12)
            commentTextView.textColor = MAIN_BLACK2
            commentTextView.returnKeyType = .done
            commentTextView.layer.borderColor = MAIN_GRAY.cgColor
            commentTextView.layer.borderWidth = CGFloat(1)
            commentTextView.backgroundColor = .white
            commentTextView.delegate = self
            self.addSubview(commentTextView)
            
            
            let placeholderText = "评点商品，帮助商家改进，2-100字以内"
            let placeholderStrWidth = placeholderText.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
            placeholderLabel = UILabel(frame:CGRect(x: toSide + cmSizeFloat(7), y: commentTextView.frame.origin.y + cmSizeFloat(7), width: placeholderStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            placeholderLabel.text = placeholderText
            placeholderLabel.font = cmSystemFontWithSize(12)
            placeholderLabel.textColor = MAIN_GRAY
            self.addSubview(placeholderLabel)
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: WaitEvaluateTabcell.cellHeight - CGFloat(1)))
        }
        
    }
    
    
    
    //MARK: - 设置Model
    func setModel(model:OrderWaitEvaluateCellModel,indexRow:Int){
        currentIndex = indexRow
        goodsNameLabel.text = model.GoodsName
        commentTextView.text = model.evaluateContent
        if commentTextView.text.isEmpty{
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
            if index <= model.evaluateScore {
                starBtn.setImage(selectedScore, for: .normal)
            }else{
               starBtn.setImage(unselectedScore, for: .normal)
            }
            starBtn.tag = 200 + index
            starBtn.addTarget(self, action: #selector(selectedStarAct(sender:)), for: .touchUpInside)
            evaluateScoreView.addSubview(starBtn)
        }
        
    }
    
    //MARK: - 进行评分
    @objc func selectedStarAct(sender:UIButton){
        
        if let cuurentVC = GetCurrentViewController() as? OrderEvaluateVC {
            cuurentVC.evaluateModel.waitEvaluateGoodsModelArr[currentIndex].evaluateScore = sender.tag - 200
            let indexPath = IndexPath(row: currentIndex, section: 0)
            cuurentVC.mainTabView.reloadRows(at: [indexPath], with: .none)
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
