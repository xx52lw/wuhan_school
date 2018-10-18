//
//  XYRefreshFooter.swift
//  
//
//  Created by xiaoyi on 2017/7/13.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import MJRefresh
class XYRefreshFooter: MJRefreshAutoNormalFooter {

    override func prepare() {
        super.prepare()
        self.setTitle("全部加载完成", for: .noMoreData)
        self.setTitle("", for: .idle)
        self.setTitle("上拉加载更多", for: .refreshing)
//        self.isAutomaticallyHidden = true
    }
    
    //重写所有数据全部加载完毕方法，隐藏上拉footer
    override func endRefreshingWithNoMoreData() {
        super.endRefreshingWithNoMoreData()
        //self.isHidden = true
    }
    
    
}
