//
//  BBSettingButtonTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import Common

class BBSettingButtonTableViewCell: BBSettingTitleTableViewCell {
    lazy var button = BBSettingButtonTableViewCellButton()
    var buttonItem: BBSettingButtonItem?{
        didSet{
            
            guard let buttonItem = buttonItem else { return }
            button.setTitle(buttonItem.content, for: .normal)
            button.setTitle(buttonItem.placeholder, for: .selected)
            button.bb_setTitleColor(buttonItem.contentColor ?? .darkGray, for: .normal)
            button.titleLabel?.font = buttonItem.contentFont
            button.titleLabel?.textAlignment = buttonItem.textAlignment ?? .left
            button.isSelected = buttonItem.content == nil
            button.isUserInteractionEnabled = buttonItem.buttonIsUserInteractionEnabled
        }
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if let buttonItem = item as? BBSettingButtonItem {
            self.buttonItem = buttonItem
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func displayed() {
        super.displayed()
        
        button.frame = CGRect(x: titleLabel.frame.maxX,
                              y: 0,
                              width: contentView.frame.width - titleLabel.frame.maxX,
                              height: contentView.frame.height)
    }

}

class BBSettingButtonTableViewCellButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.width, height: contentRect.height)
    }
}
