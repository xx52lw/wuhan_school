//
//  MerchantArbitrationEvidenceSubmitVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import AVFoundation
class MerchantArbitrationEvidenceSubmitVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    let toside = cmSizeFloat(10)
    let TAGE_WIDTH = (SCREEN_WIDTH - cmSizeFloat(4*2) - cmSizeFloat(10*2))/3

    
    var topView:XYTopView!
    var headerLabel:UILabel!
    var  alertView:XYCommonAlertView!

    var collectionView:UICollectionView!
    var statusStr:String!
    var userOrderId:String!
    //选择的图片
    var chooseImageArray:[UIImage] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createViewHeader()
        createCollectionView()
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建collectionViewHeader
    func createViewHeader(){
        
        headerLabel  = UILabel(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height:cmSizeFloat(40)))
        headerLabel.font = cmSystemFontWithSize(14)
        headerLabel.textColor = MAIN_BLACK
        headerLabel.textAlignment = .center
        headerLabel.text = statusStr
        self.view.addSubview(headerLabel)
        
        self.view.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: headerLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
        
    }


    
    //MARK: - 创建collectionview
    func createCollectionView(){
        
        
        //MARK:collectionView
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect(x: toside, y: headerLabel.bottom + cmSizeFloat(7+10), width: SCREEN_WIDTH - toside*2, height: SCREEN_HEIGHT-(headerLabel.bottom+cmSizeFloat(7+10))), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.itemSize = CGSize(width: TAGE_WIDTH, height: TAGE_WIDTH + cmSizeFloat(35))
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = cmColorWithString(colorName: "ffffff")
        collectionView.register(MerchantChoosePicCollectionCell.self, forCellWithReuseIdentifier: "MerchantChoosePicCollectionCell")
        collectionView.register(ChoosePicCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ChoosePicCollectionFooterView")
        self.view.addSubview(collectionView)
        
        
    }
    
    
    //MARK: - delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chooseImageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantChoosePicCollectionCell", for: indexPath) as? MerchantChoosePicCollectionCell
        cell?.selectedImageView.image = self.chooseImageArray[indexPath.row]
        cell?.cellIndex = indexPath.row
        if cell == nil{
            cell = MerchantChoosePicCollectionCell()
        }
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cmSizeFloat(1)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (SCREEN_WIDTH - TAGE_WIDTH*3 - toside*2)/3
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0 )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
           let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoosePicCollectionFooterView", for: indexPath) as! ChoosePicCollectionFooterView
            if self.chooseImageArray.count > 0 {
                header.updateBtn.isHidden = false
                
            }else{
                header.updateBtn.isHidden = true
            }
            return header
                
        }else{
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "testHeader", for: indexPath)
        }
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: SCREEN_WIDTH, height: cmSizeFloat(50))
        return size
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem().rightStrBtnItem(target: self, action: #selector(choosePicAct), btnStr: "添加", fontSize: 15))
        topView.titleLabel.text = "订单证据"
    }
    
    //MARK: - 图片选择响应
    @objc func  choosePicAct(){
        if self.chooseImageArray.count >= 3 {
            cmShowHUDToWindow(message: "最多只能上传3张图片")
            return
        }
        let btnTextArr = ["拍照","从相册中选择","取消"]
         alertView = XYCommonAlertView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: cmSizeFloat(45)*CGFloat(btnTextArr.count)), btnStrArr: btnTextArr) { [weak self]  (selectedTag) in
            switch selectedTag {
            case 0:
                self?.authorizationCamera(self!.photoCamera)
                self?.alertView.hideInView()
                break
            case 1:
                let albumManager = XYAlbumManager(maxSelectedNumber: 3 - self!.chooseImageArray.count, title: "选择相片")
                albumManager.showAlbum {  (images) in
                    self?.chooseImageArray.append(contentsOf: images)
                    self?.collectionView.reloadData()
                }
                self?.alertView.hideInView()
                break
            case 2:
                self?.alertView.hideInView()
                break
            default:
                break
            }
        }
        
        self.view.addSubview(alertView)
        alertView.showInView(view: self.view)
    }
    


    
    //相机权限
    private func authorizationCamera(_ method: @escaping () -> ()) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .restricted || status == .denied {
            cmShowHUDToWindow(message: "请开启相机权限")
        } else {
            method()
        }
    }
    
    private func photoCamera() {
        let pickImageVC = UIImagePickerController()
        pickImageVC.delegate = self
        pickImageVC.sourceType = .camera
        present(pickImageVC, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chooseImageArray.append(image)
            self.collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
