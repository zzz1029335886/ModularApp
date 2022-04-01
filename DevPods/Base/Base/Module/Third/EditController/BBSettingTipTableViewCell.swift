//
//  BBSettingTipTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2019/1/8.
//  Copyright © 2019 zerry. All rights reserved.
//

import UIKit

class BBSettingTipTableViewCell: BBSettingTableViewCell {
    
    var tipLabel = UILabel.init(frame: .zero)
    var tipItem : BBSettingTipItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = tipLabel
        label.numberOfLines = 0
        self.contentView.addSubview(label)
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
        
        guard let tipItem = item as? BBSettingTipItem else { return }
        self.tipLabel.text = tipItem.title
        self.tipLabel.font = tipItem.titleFont
        self.tipLabel.textColor = tipItem.titleTextColor
        self.tipLabel.textAlignment = tipItem.titleAlignment ?? .left
        self.tipItem = tipItem
    }
    
    override func displayed() {
        super.displayed()
        
        guard let tipItem = tipItem else { return }
        self.tipLabel.frame = .init(x: tipItem.titleLabelPadding,
                                    y: 0,
                                    width: contentView.frame.width - tipItem.titleLabelPadding * 2,
                                    height: contentView.frame.height)
    }

}
