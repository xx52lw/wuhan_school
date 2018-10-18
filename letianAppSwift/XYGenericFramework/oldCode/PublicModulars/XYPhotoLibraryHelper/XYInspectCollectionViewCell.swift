//
//  XYInspectCollectionViewCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import Photos
class XYInspectCollectionViewCell: UICollectionViewCell {
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    func photoBrowerData(by asset: PHAsset) {
        XYAlbumHelper.getImage(by: asset, complectionImage: nil) { [unowned self] (image) in
            self.imageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
