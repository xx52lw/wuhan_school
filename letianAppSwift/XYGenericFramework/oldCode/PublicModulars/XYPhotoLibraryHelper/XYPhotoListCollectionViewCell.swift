//
//  XYPhotoListCollectionViewCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class XYPhotoListCollectionViewCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    
    private(set) var selectedButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.mas_makeConstraints { [unowned self] (make) in
            make?.edges.mas_equalTo()(self.contentView)
        }
        
        selectedButton.layer.cornerRadius = 9.5
        selectedButton.layer.masksToBounds = true
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(selectedButton)
        selectedButton.mas_makeConstraints { [unowned self] (make) in
            make?.right.mas_equalTo()(self.contentView.mas_right)?.offset()(-4)
            make?.top.mas_equalTo()(self.contentView.mas_top)?.offset()(4)
            make?.size.mas_equalTo()(CGSize(width: 19, height: 19))
        }
    }
    
    func imagePickerImage(_ asset: XYAsset) {
        let phAsset = asset.asset
        XYAlbumHelper.getImage(by: phAsset, complectionImage: CGSize(width: 200, height: 200)) { [unowned self] (image) in
            self.imageView.image = image
        }
        
        if asset.selected == true {
            selectedButton.backgroundColor = MAIN_BLUE
            selectedButton.setTitle("\(asset.tag)", for: .normal)
            
        } else {

            selectedButton.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.4)
            selectedButton.setTitle(nil, for: .normal)
        }
    }
    
    func selectedStatus(_ selected: Bool) {
        selectedButton.isSelected = selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

