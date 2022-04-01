//
//  BBSettingTextFieldTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import MBProgressHUD

class BBSettingTextFieldTableViewCell: BBSettingTopTitleTableViewCell {
    var textField: UITextField!
    var textFieldItem: BBSettingTextFieldItem?{
        didSet{
            configTextField()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if let textFieldItem = item as? BBSettingTextFieldItem {
            self.textFieldItem = textFieldItem
            
            if textFieldItem.textField != nil{
                textField.removeFromSuperview()
                textField = nil
                textField = textFieldItem.textField
//                contentView.addSubview(textField)
                
                self.setTextField()
                self.configTextField()
            }
            
            textFieldItem.systemTextField = textField
            
            
            //            if textFieldItem.validateType != nil{
            //                textField.delegate = self
            //            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTextField()
    }
    
    func setTextField() {
        if textField == nil {
            textField = UITextField.init()
        }
        self.contentView.addSubview(textField)
    }
    
    func configTextField() {
        guard let textFieldItem = textFieldItem else { return }
        
        textField.placeholder = textFieldItem.placeholder
        textField.font = textFieldItem.contentFont
        textField.text = textFieldItem.content
        textField.keyboardType = textFieldItem.keyboardType
        textField.isSecureTextEntry = textFieldItem.isSecureTextEntry
        textField.textAlignment = textFieldItem.textAlignment ?? .left
        textField.delegate = self
        textField.returnKeyType = textFieldItem.returnKeyType
        textField.clearButtonMode = .whileEditing
        textField.textColor = textFieldItem.contentColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func displayed() {
        super.displayed()
        
        guard let textFieldItem = textFieldItem else { return }
        
        let x = textFieldItem.isBottom ? titleLabel.frame.minX : textFieldItem.titleLabelWidth + textFieldItem.titleLabelPadding
        let y = textFieldItem.isBottom ? titleLabel.frame.maxY : titleLabel.frame.minY
        
        var width = contentView.frame.width - x - textFieldItem.titleLabelPadding
        if let rightView = textFieldItem.rightView{
            width = rightView.frame.minX - x - textFieldItem.rightViewLeftPadding
        }
        
        textField.frame = CGRect(x: x,
                                 y: y,
                                 width: width,
                                 height: contentView.frame.height - y * 2)
        
    }
    
}
extension BBSettingTextFieldTableViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textFieldItem = textFieldItem else { return }
        self.controller?.delegate?.settingViewController(textFieldItem, didBeginEditing: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let textFieldItem = textFieldItem else { return }
        
        if let validateType = textFieldItem.validateType {
            guard let text = textField.text else { return }
            if validateType.isError(text){
                textFieldItem.validateState = false
                if let validateError = textFieldItem.validateError{
                    MBProgressHUD.showText(validateError)
                }
            }else{
                textFieldItem.validateState = true
            }
        }
        
        textFieldItem.content = textField.text?.count == 0 ? nil : textField.text
        self.controller?.delegate?.settingViewController(textFieldItem, didEndEditing: textField)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldItem = textFieldItem else { return false }
        
        if  string != "",
            let text = textField.text,
            text.count + string.count > textFieldItem.contentLimitCount {
            return false
        }
        
        for char in string {
            if char.isEmoji{
                MBProgressHUD.showText("暂不支持输入表情")
                return false
            }
        }
        
        if string == "\n"{
            textFieldItem.content = textField.text
            self.controller?.delegate?.settingViewController(textFieldItem, didEndEditing: textField)
        }else{
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            self.controller?.delegate?.settingViewController(textFieldItem, textChanged: replacementText.isEmpty ? nil : replacementText)
        }
        
        return true
    }
    
    
}
