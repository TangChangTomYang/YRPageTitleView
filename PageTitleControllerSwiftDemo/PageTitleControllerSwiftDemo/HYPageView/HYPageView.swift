//
//  HYPageView.swift
//  04-HYPageView设计
//
//  Created by 小码哥 on 2016/12/4.
//  Copyright © 2016年 xmg. All rights reserved.
//

import UIKit

class HYPageView: UIView {
    
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var style : HYTitleStyle
    
    fileprivate var titleView : HYTitleView!
    
    init(frame: CGRect, titles : [String], childVcs : [UIViewController], parentVc : UIViewController, style : HYTitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension HYPageView {
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = HYTitleView(frame: titleFrame, titles: titles, style : style)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
    }
    
    private func setupContentView() {
        // ?.取到类型一定是可选类型
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = HYContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        
        // 2.contentView&titleView代理设置
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
