//
//  BBSettingSwitchTableViewCell.swift
//  shishi
//
//  Created by zerry on 2019/7/22.
//  Copyright © 2019 zerry. All rights reserved.
//

import UIKit

protocol BBSettingSwitchTableViewCellDelegate: AnyObject {
    func settingSwitchTableViewCellValueChanged(_ cell: BBSettingSwitchTableViewCell, isOn: Bool)
}

class BBSettingSwitchTableViewCell: BBSettingTitleTableViewCell {

    var switchItem : BBSettingSwitchItem?{
        didSet{
            guard let switchItem = switchItem else { return }
            self.switchButton.isOn = switchItem.isOn
            self.switchButton.onTintColor = switchItem.onTintColor
        }
    }
    
    var switchButton : UISwitch!
    weak var delegate : BBSettingSwitchTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .none
        
        let switch0 = UISwitch.init()
        switch0.addTarget(self, action: #selector(switch0Changed(_:)), for: UIControl.Event.valueChanged)
        self.contentView.addSubview(switch0)
        self.switchButton = switch0
    }
    
    @objc func switch0Changed(_ switch0:UISwitch) {
        self.delegate?.settingSwitchTableViewCellValueChanged(self, isOn: switch0.isOn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if let switchItem = item as? BBSettingSwitchItem{
            self.switchItem = switchItem
        }
    }

    override func displayed() {
        super.displayed()
        
        let frame = self.switchButton.frame
        self.switchButton.center = .init(x: self.contentView.frame.width - frame.width * 0.5 - 15, y: self.contentView.frame.height * 0.5)
        
    }
}
