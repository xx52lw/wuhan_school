//
//  MerchantChoosePicCollectionCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantChoosePicCollectionCell: UICollectionViewCell {

    let imageSpace = cmSizeFloat(4)
    let selectedImageWidth = (SCREEN_WIDTH - cmSizeFloat(4*2) - cmSizeFloat(10*2))/3
    let deleBtnHeight = cmSizeFloat(35)
    
    //图片
    var selectedImageView:UIImageView!
    var deleteBtn:UIButton!
    var cellIndex:Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: selectedImageWidth, height:  selectedImageWidth))
        self.addSubview(selectedImageView)
        
        
        deleteBtn = UIButton(frame: CGRect(x: 0, y: selectedImageView.bottom, width: selectedImageWidth, height: deleBtnHeight))
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(MAIN_BLUE, for: .normal)
        deleteBtn.titleLabel?.font = cmSystemFontWithSize(14)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
        self.addSubview(deleteBtn)

        
    }
    
    
    //MARK: - 删除当前已选图片
    @objc func deleteBtnAct(){
        if let currentVC = GetCurrentViewController() as? MerchantArbitrationEvidenceSubmitVC {
            currentVC.chooseImageArray.remove(at: cellIndex)
            currentVC.collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
