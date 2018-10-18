//
//  EvaluateNoAnswerTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/19.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class EvaluateNoAnswerTabCell: UITableViewCell {

    
    let toLeftSide = cmSizeFloat(10)
    let avatarWidthHeight = cmSizeFloat(35)
    let avatarToTop = cmSizeFloat(10)
    let userNameToAvatarWidth = cmSizeFloat(8)
    let gradeToCommentHeight = cmSizeFloat(5)
    let gradeViewHeight = cmSizeFloat(24)

    let unselectStar = #imageLiteral(resourceName: "evaluateStar")
    let selectedStar = #imageLiteral(resourceName: "evaluateSelectedStar")
    
    //头像
    var avatarBtn:UIButton!
    //用户名
    var userNameLab:UILabel!
    //评分星星
    var gradeView:UIView!
    //评论内容
    var commentContentLab:UILabel!
    //发布时间
    var commentTimeLab:UILabel!
    //分割线
    var sperateLine:UIView!
    
    var model:EvaluateCellModel!
    //评分星星数组
    var starsImageViewArr:[UIImageView] = Array()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            avatarBtn = UIButton(frame: CGRect(x: toLeftSide, y: avatarToTop, width: avatarWidthHeight, height: avatarWidthHeight))
            avatarBtn.layer.cornerRadius = avatarWidthHeight/2
            avatarBtn.clipsToBounds = true
            avatarBtn.addTarget(self, action: #selector(avatarBtnAct), for: .touchUpInside)
            self.addSubview(avatarBtn)
            
            userNameLab = UILabel(frame:CGRect(x: avatarBtn.frame.maxX + userNameToAvatarWidth, y: avatarToTop , width: SCREEN_WIDTH/2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            userNameLab.font = UIFont.systemFont(ofSize: 14)
            userNameLab.textColor =  MAIN_BLACK
            userNameLab.textAlignment = .left
            self.addSubview(userNameLab)
            
            gradeView = UIView(frame: CGRect(x: avatarBtn.right + userNameToAvatarWidth, y: userNameLab.bottom + gradeToCommentHeight, width: selectedStar.size.width * CGFloat(5), height: gradeViewHeight))
            for index in 0..<5{
                let imageView = UIImageView(frame: CGRect(x: selectedStar.size.width * CGFloat(index), y: gradeViewHeight/2 - selectedStar.size.height/2, width: selectedStar.size.width, height: selectedStar.size.height))
                imageView.image = selectedStar
                gradeView.addSubview(imageView)
                starsImageViewArr.append(imageView)
            }
            self.addSubview(gradeView)

            
            commentContentLab = UILabel(frame: .zero)
            commentContentLab.font = UIFont.systemFont(ofSize: 13)
            commentContentLab.textColor =  MAIN_BLACK2
            commentContentLab.numberOfLines = 0
            self.addSubview(commentContentLab)
            
            
            commentTimeLab = UILabel(frame: .zero)
            commentTimeLab.font = UIFont.systemFont(ofSize: 13)
            commentTimeLab.textColor =  MAIN_GRAY
            self.addSubview(commentTimeLab)
            
            
            sperateLine = XYCommonViews.creatCommonSeperateLine(pointY: 0)
            self.addSubview(sperateLine)
            
            self.backgroundColor = .white
        }
    }
    
    

    
    

    
    

    

    
    
    //MARK: - 点击头像进入用户界面
    @objc func avatarBtnAct(){

    }
    
    func setModel(model:EvaluateCellModel){
        //评论用户ID
        self.model = model
        
        let userNameWidth = (SCREEN_WIDTH - toLeftSide - avatarWidthHeight - userNameToAvatarWidth)/2
        userNameLab.frame.size.width = userNameWidth
        userNameLab.text = model.userName
        
        
        
        
        let commentTimeWidth = model.evaluateTime.stringWidth(.greatestFiniteMagnitude, font: cmSystemFontWithSize(13))
        commentTimeLab.frame = CGRect(x: SCREEN_WIDTH - commentTimeWidth - toLeftSide, y: userNameLab.bottom - cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))/2 - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))/2, width: commentTimeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        commentTimeLab.text = model.evaluateTime
        
        
        
        //星星设置
        for  index in  0..<5 {
            starsImageViewArr[index].image = selectedStar
        }
        
        if Int(model.score) < 5 {
            for index in  Int(model.score)..<5 {
                starsImageViewArr[index].image = unselectStar
            }
        }
        
        
        let commentContentWidth = SCREEN_WIDTH - avatarBtn.right - userNameToAvatarWidth - toLeftSide
        let commentContentHeiht =  model.evaluateContent.stringHeight(commentContentWidth, font: cmSystemFontWithSize(13))
                commentContentLab.frame = CGRect(x: avatarBtn.frame.maxX + userNameToAvatarWidth, y: gradeView.bottom + gradeToCommentHeight, width: commentContentWidth, height: commentContentHeiht)
        commentContentLab.text = model.evaluateContent
        
        sperateLine.frame.origin.y = commentContentLab.bottom + gradeToCommentHeight
        
        avatarBtn.sd_setBackgroundImage(with: URL(string:model.userAvatar), for: .normal, placeholderImage:#imageLiteral(resourceName: "placeHolderImage"))
        
        //self.frame = CGRect(x: 0, y: 0, width: XY_SCREEN_WIDTH, height: sperateLine.frame.maxY )
        
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
