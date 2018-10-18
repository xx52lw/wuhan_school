//
//  SearchTableViewCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    private let toside = cmSizeFloat(18)
    private let cellHeight = cmSizeFloat(44)
    
    var searchHistoryLabel:UILabel!
    private var lineView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            searchHistoryLabel = UILabel(frame:CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height: cellHeight))
            searchHistoryLabel.textColor = MAIN_GRAY
            searchHistoryLabel.font = UIFont.systemFont(ofSize: 14)
            searchHistoryLabel.textAlignment = .left
            self.addSubview(searchHistoryLabel)
            
            lineView = XYCommonViews.creatCommonSeperateLine(pointY: searchHistoryLabel.frame.maxY - 1)
            lineView.frame.size.height = 1
            self.addSubview(lineView)
            
            self.backgroundColor = cmColorWithString(colorName: "ffffff")
            
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
