//
//  XYCommonViews.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/3.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

let seperateLineColor = cmColorWithString(colorName: "eeecec")

class XYCommonViews: UIView {

    
   class func creatCommonSeperateLine(pointY:CGFloat) -> UIView{
        let seperateLabel = UIView(frame: CGRect(x: 0, y: pointY, width: SCREEN_WIDTH, height: cmSizeFloat(1)))
        seperateLabel.backgroundColor =  seperateLineColor
        return seperateLabel
        
    }
    
    
    
    class func creatCustomSeperateLine(pointY:CGFloat,lineWidth:CGFloat,lineHeight:CGFloat) -> UIView{
        let seperateLabel = UIView(frame: CGRect(x: 0, y: pointY, width: lineWidth, height: lineHeight))
        seperateLabel.backgroundColor =  seperateLineColor
        
        return seperateLabel
        
    }
    
    

    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
