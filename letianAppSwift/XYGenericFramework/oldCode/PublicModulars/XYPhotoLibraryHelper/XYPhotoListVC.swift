//
//  XYPhotoListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import Photos

class XYPhotoListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var maxSelectedNumber = 0
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    var callBack: AlbumResult?
    
    private var collectionView: UICollectionView!
    
    private var dataArray: [XYAsset] = []
    
    private var selectedArray: [XYAsset] = []
    
    private var footerView: UIView!
    
    private var verbButton: UIButton!
    
    private var finishButton: UIButton!
    private var topView:XYTopView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = fetchResult {
            let assets = XYAlbumHelper.getPhotoAssets(fetchResult!)
            for asset in assets {
                let xyAsset = XYAsset(false, asset, 0)
                dataArray.append(xyAsset)
            }
        }
        creatNavTopView()
        setupSubviews()
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: #selector(leftBtnAct)).navigationTitleItem())
        topView.titleLabel.text = "图片证据选择"
    }
    
    @objc func leftBtnAct() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSubviews() {
        let photoSize: CGFloat = (UIScreen.main.bounds.width - 15.0) / 4.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
        flowLayout.itemSize = CGSize(width: photoSize, height: photoSize)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - topView.bottom - 44), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .white
        collectionView?.isUserInteractionEnabled = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        
        collectionView?.register(XYPhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "XYPhotoListCollectionViewCell")
        
        footerView = UIView()
        footerView.backgroundColor =   cmColorWithString(colorName: "353535")
        view.addSubview(footerView)
        footerView.mas_makeConstraints { [unowned self] (make) in
            make?.bottom.mas_equalTo()(self.view.mas_bottom)
            make?.left.mas_equalTo()(self.view.mas_left)
            make?.right.mas_equalTo()(self.view.mas_right)
            make?.height.mas_equalTo()(44)
        }
        
        verbButton = UIButton()
        verbButton.setTitle("预览", for: .normal)
        verbButton.setTitle("预览", for: .highlighted)
        verbButton.setTitleColor(cmColorWithString(colorName: "ffffff"), for: .normal)
        verbButton.setTitleColor(cmColorWithString(colorName: "ffffff"), for: .highlighted)
        verbButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        verbButton.addTarget(self, action: #selector(verbButtonAction(_:)), for: .touchUpInside)
        footerView.addSubview(verbButton)
        verbButton.mas_makeConstraints { [unowned self] (make) in
            make?.left.mas_equalTo()(self.footerView.mas_left)?.offset()(33)
            make?.top.mas_equalTo()(self.footerView.mas_top)
            make?.bottom.mas_equalTo()(self.footerView.mas_bottom)
        }
        
        finishButton = UIButton()
        finishButton.setTitle("完成(0)", for: .normal)
        finishButton.setTitle("完成(0)", for: .highlighted)
        finishButton.setTitleColor(cmColorWithString(colorName: "ffffff"), for: .normal)
        finishButton.setTitleColor(cmColorWithString(colorName: "ffffff"), for: .highlighted)
        finishButton.backgroundColor = MAIN_BLUE
        finishButton.layer.cornerRadius = 4
        finishButton.layer.masksToBounds = true
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        finishButton.addTarget(self, action: #selector(finishButtonAction(_:)), for: .touchUpInside)
        footerView.addSubview(finishButton)
        finishButton.mas_makeConstraints { [unowned self] (make) in
            make?.right.mas_equalTo()(self.footerView.mas_right)?.offset()(-13)
            make?.centerY.mas_equalTo()(self.footerView.mas_centerY)
            make?.size.mas_equalTo()(CGSize(width: 73, height: 30))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XYPhotoListCollectionViewCell", for: indexPath) as? XYPhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let xyAsset = dataArray[indexPath.row]
        cell.imagePickerImage(xyAsset)
        cell.selectedButton.tag = indexPath.row
        cell.selectedButton.isSelected = xyAsset.selected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? XYPhotoListCollectionViewCell {
            //cell.selectedButton.palpitateAnimation()
        }
        
        selectedAlbumImage(indexPath.row)
    }
    
    @objc private func selectedAlbumImage(_ index: Int) {
        let xyAsset = dataArray[index]
        
        if xyAsset.selected == true {
            xyAsset.selected = false
            xyAsset.tag = 0
            if let index = selectedArray.index(of: xyAsset) {
                selectedArray.remove(at: index)
            }
        } else {
            if selectedArray.count >= maxSelectedNumber {
                cmShowHUDToWindow(message: "最多可以选择\(maxSelectedNumber)张图片")
                return
            }
            
            xyAsset.selected = true
            selectedArray.append(xyAsset)
        }
        
        var reloadItems: [IndexPath] = []
        for (index, element) in selectedArray.enumerated() {
            element.tag = index + 1
            if let i = dataArray.index(of: element) {
                reloadItems.append(IndexPath(row: i, section: 0))
            }
        }
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        collectionView.reloadItems(at: reloadItems)
        
        updateFinishButtonTitle(selectedArray.count)
    }
    
    @objc private func verbButtonAction(_ sender: UIButton) {
        let verbVC = XYInspectViewController()
        verbVC.dataArray = selectedArray
        navigationController?.pushViewController(verbVC, animated: true)
    }
    
    @objc private func finishButtonAction(_ sender: UIButton) {
        if selectedArray.count <= 0 {
            cmShowHUDToWindow(message: "还没有选择图片哦")
            return
        }
        
        var imageArray: [UIImage] = []
        for lmAsset in selectedArray {
            XYAlbumHelper.getImage(by: lmAsset.asset, complectionImage: nil, isHighQuality: false, isSynchronous: true, complection: { (image) in
                if let _ = image {
                    imageArray.append(image!)
                }
            })
        }
        
        callBack?(imageArray)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateFinishButtonTitle(_ count: Int) {
        finishButton.setTitle("完成(\(count))", for: .normal)
        finishButton.setTitle("完成(\(count))", for: .highlighted)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
    }
}

