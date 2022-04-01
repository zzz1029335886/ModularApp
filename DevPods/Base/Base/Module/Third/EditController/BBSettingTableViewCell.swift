//
//  BBSettingTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit

public class BBSettingTableViewCell: UITableViewCell {
    var baseItem: BBSettingItem?
    weak var controller : BBSettingViewController?
    lazy var lineView = UIView()
    weak var rightView: UIView?
    
    func setItem(_ item: BBSettingItem) {
        self.baseItem = item
        contentView.backgroundColor = item.backgroundColor
        
        if let titleItem = baseItem as? BBSettingTitleItem {
            if let rightView = titleItem.rightView{
                self.rightView = rightView
                contentView.addSubview(rightView)
            }else{
                if rightView?.superview == contentView{
                    rightView?.removeFromSuperview()
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        lineView.isHidden = true
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func willDisplay() {
        displayed()
    }
    
    func didDisplay() {
        displayed()
    }
    
    func displayed() {
        
        guard let baseItem = baseItem else { return }
        self.contentView.isUserInteractionEnabled = baseItem.isUserInteractionEnabled
        
        if let separatorColor = baseItem.separatorColor {
            lineView.isHidden = false
            lineView.backgroundColor = separatorColor
            if let separatorInsets = baseItem.separatorInsets {
                contentView.bringSubviewToFront(lineView)
                lineView.frame = .init(x: separatorInsets.left,
                                       y: frame.height - separatorInsets.bottom - 0.75,
                                       width: frame.width - separatorInsets.left - separatorInsets.right,
                                       height: 0.75)
            }
        }else{
            lineView.isHidden = true
        }
    }
}

