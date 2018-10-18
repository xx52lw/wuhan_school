//
//  MapLocationCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/22.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MapLocationCell: UITableViewCell {

    static var cellHeight = cmSizeFloat(12*2+6) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))
    let toside = cmSizeFloat(15)
    let textToimageWidth = cmSizeFloat(15)
    let textSpaceHeight = cmSizeFloat(6)
    let toTop = cmSizeFloat(12)
    
    let locationImage = #imageLiteral(resourceName: "locationAdress")
    
    var locationImageView:UIImageView!
    var resultNameLabel:UILabel!
    var resultAdressLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            locationImageView = UIImageView(frame: CGRect(x: toside, y: MapLocationCell.cellHeight/2 - locationImage.size.height/2, width: locationImage.size.width, height: locationImage.size.height))
            locationImageView.image = locationImage
            self.addSubview(locationImageView)
            
            resultNameLabel = UILabel(frame: CGRect(x: locationImageView.right + textToimageWidth, y: toTop, width: SCREEN_WIDTH - locationImageView.right - toside - textToimageWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            resultNameLabel.font = cmBoldSystemFontWithSize(14)
            resultNameLabel.textColor = MAIN_BLACK
            resultNameLabel.textAlignment = .left
            self.addSubview(resultNameLabel)
            
            resultAdressLabel = UILabel(frame: CGRect(x: locationImageView.right + textToimageWidth, y: resultNameLabel.bottom + textSpaceHeight, width: SCREEN_WIDTH - locationImageView.right - toside - textToimageWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            resultAdressLabel.font = cmBoldSystemFontWithSize(12)
            resultAdressLabel.textColor = MAIN_GRAY
            resultAdressLabel.textAlignment = .left
            self.addSubview(resultAdressLabel)
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: MapLocationCell.cellHeight - cmSizeFloat(1)))
            
            
        }
    }
    
    
    func setModel(model:NearbySearchResultModel,index:Int) {
        resultAdressLabel.text = model.resultAdress
        
        if let currentVC = GetCurrentViewController() as? MapLocationVC {
        //富文本显示数量
        if index == 0 && currentVC.currentResultModelArr.first!.resultName == model.resultName{
        let currentLocationStr = "[当前]  " + model.resultName
        let currentLocationRange:NSRange = NSMakeRange(0, 4)
        let currentLocationString = NSMutableAttributedString(string: currentLocationStr as String)
            currentLocationString.addAttribute(NSAttributedStringKey.foregroundColor, value: MAIN_BLUE, range: currentLocationRange)
            resultNameLabel.attributedText = currentLocationString
        }else{
            resultNameLabel.text = model.resultName
        }
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
