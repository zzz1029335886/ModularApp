//
//  BBSettingCustomContentTableViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/9/14.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

class BBSettingCustomContentTableViewCell: BBSettingTitleTableViewCell {
    weak var customView : UIView?
    var customContentItem : BBSettingCustomContentItem?
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        guard let customContentItem = item as? BBSettingCustomContentItem else { return }
        self.customContentItem = customContentItem
        
        self.accessoryType = customContentItem.accessoryType
        self.customView?.removeFromSuperview()
        
        if let customView = customContentItem.view{
            contentView.addSubview(customView)
            self.customView = customView
        }
    }
    
    override func displayed() {
        super.displayed()
        
        guard let customView = customView else { return }
        customView.frame = CGRect(x: titleLabel.frame.maxX,
                                  y: 0,
                                  width: contentView.frame.width - titleLabel.frame.maxX,
                                  height: contentView.frame.height)
        
    }
}
