//
//  XYPhotoLibraryManage.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import Photos

typealias AlbumResult = ([UIImage]) -> Void

public class XYAsset: NSObject {
    
    var selected: Bool
    
    var asset: PHAsset
    
    var tag: Int
    
    init(_ selected: Bool, _ asset: PHAsset, _ tag: Int) {
        self.selected = selected
        self.asset = asset
        self.tag = tag
        super.init()
    }
}

final class XYAlbumManager: NSObject {
    fileprivate var resultCallback: AlbumResult?
    
    fileprivate var maxSelectedNumber: Int
    
    fileprivate var title: String
    
    init(maxSelectedNumber: Int, title: String = "相册") {
        self.maxSelectedNumber = maxSelectedNumber
        self.title = title
        super.init()
    }
    
    public func showAlbum(_ resultCallback: @escaping AlbumResult) {
        self.resultCallback = resultCallback
        AuthorizationAlbum(pushAlbumViewController)
    }
    
    private func pushAlbumViewController() {
        let albumListVC = XYPhotoListViewController()
        albumListVC.maxSelectedNumber = maxSelectedNumber
        albumListVC.callBack = resultCallback
        albumListVC.fetchResult = XYAlbumHelper.getCameraRollFetchResult()
        albumListVC.title = title
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let nav = UINavigationController(rootViewController: albumListVC)
        rootVC?.present(nav, animated: true, completion: nil)
    }
    
    //相册权限
    func AuthorizationAlbum(_ method: @escaping () -> ()) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            cmShowHUDToWindow(message: "保存失败，请开启相册权限")
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        method()
                    } else {
                        cmShowHUDToWindow(message: "保存失败，请开启相册权限")
                    }
                }
            })
        } else {
            method()
        }
    }
}

