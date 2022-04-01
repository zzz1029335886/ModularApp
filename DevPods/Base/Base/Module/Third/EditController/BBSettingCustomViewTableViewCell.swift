//
//  BBSettingCustomViewTableViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/3/29.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

class BBSettingCustomViewTableViewCell: BBSettingTableViewCell {
    weak var customView : UIView?
    var customViewItem : BBSettingCustomViewItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        guard let customViewItem = item as? BBSettingCustomViewItem else { return }
        self.customViewItem = customViewItem
        
        self.customView?.removeFromSuperview()
        
        if let customView = customViewItem.view{
            contentView.addSubview(customView)
            self.customView = customView
        }
    }
}
