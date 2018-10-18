//
//  MapSearchResultCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/23.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MapSearchResultCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(12*2+6) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))
    let toside = cmSizeFloat(20)
    let textSpaceHeight = cmSizeFloat(6)
    let toTop = cmSizeFloat(12)
    
    
    var resultNameLabel:UILabel!
    var resultAdressLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            resultNameLabel = UILabel(frame: CGRect(x: toside, y: toTop, width: SCREEN_WIDTH  - toside*2 , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            resultNameLabel.font = cmBoldSystemFontWithSize(14)
            resultNameLabel.textColor = MAIN_BLACK
            resultNameLabel.textAlignment = .left
            self.addSubview(resultNameLabel)
            
            resultAdressLabel = UILabel(frame: CGRect(x: toside, y: resultNameLabel.bottom + textSpaceHeight, width: SCREEN_WIDTH  - toside*2 , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            resultAdressLabel.font = cmBoldSystemFontWithSize(12)
            resultAdressLabel.textColor = MAIN_GRAY
            resultAdressLabel.textAlignment = .left
            self.addSubview(resultAdressLabel)
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: MapLocationCell.cellHeight - cmSizeFloat(1)))
        }
    }
    
    
    func setModel(model:NearbySearchResultModel,index:Int) {
        resultAdressLabel.text = model.resultAdress
        resultNameLabel.text = model.resultName
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
