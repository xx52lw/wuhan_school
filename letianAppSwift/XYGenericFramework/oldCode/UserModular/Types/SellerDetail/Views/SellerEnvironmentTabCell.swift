//
//  SellerEnvironmentTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SellerEnvironmentTabCell: UITableViewCell {
    
    static var cellHeight = (SCREEN_WIDTH - cmSizeFloat(15*2))*0.6 + cmSizeFloat(7)
    let toside = cmSizeFloat(15)
    let imageViewWidth = SCREEN_WIDTH - cmSizeFloat(15*2)
    let imageViewHeight =  (SCREEN_WIDTH - cmSizeFloat(15*2))*0.6
    
    
    var cellImageView:UIImageView!
    var  seperateView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            cellImageView  = UIImageView(frame: CGRect(x: toside, y: 0, width: imageViewWidth, height: imageViewHeight))
            self.addSubview(cellImageView)
            
             seperateView = XYCommonViews.creatCustomSeperateLine(pointY: cellImageView.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
            
        }
        
    }
    
    
    //MARK: - 设置Model
    func setModel(imageUrlStr:String){
        if let imageUrl = URL(string:imageUrlStr){
            cellImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            cellImageView.image = #imageLiteral(resourceName: "placeHolderImage")
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
