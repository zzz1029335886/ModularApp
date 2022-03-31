//
//  UILabelExtension.swift
//  BrainBank
//
//  Created by Joker on 2021/3/9.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension UILabel{
    
    convenience init(
        text: String?,
        font: UIFont = .regular(15),
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .left
    ){
        self.init()
        
        self.font = font
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
    
    func setValues(
        text: String? = nil,
        font: UIFont? = nil,
        textColor: UIColor? = nil
    ){
        if let font = font {
            self.font = font
        }
        if let text = text {
            self.text = text
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
    }
    
    static func creatLabel(_ text: String?,
                           _ font: UIFont,
                           _ textColor: UIColor,
                           _ textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
    
    static func createBorderLabel(title: String, font: UIFont = .systemFont(ofSize: 12), boderColor: UIColor = .hex(hexString: "#FF7F00"), titleColor: UIColor = .hex(hexString: "#FF7F00"), cornerRadius: CGFloat = 15, borderWidth: CGFloat = 0.5) -> UILabel {
        let label = UILabel.creatLabel(title, font, titleColor, .center)
        label.layer.borderColor = boderColor.cgColor
        label.layer.cornerRadius = cornerRadius
        label.layer.borderWidth = borderWidth
        label.layer.masksToBounds = true
        return label
    }
    
    
    func addAttribute(_ text: String,
                      _ fontSize: CGFloat,
                      _ conformStr: String) {
        let  aString = NSMutableAttributedString.init(string: text)
        aString.addAttribute(.font, value: UIFont.systemFont(ofSize:fontSize), range: NSMakeRange(0, conformStr.count))
        self.attributedText = aString
    }
    
    static func setCreateLabel(title: String, font: UIFont,titleColor : UIColor = .hex(hexString: "#FF7F00") ,cornerRadius: CGFloat, borderWidth:CGFloat, boderColor : UIColor = .hex(hexString: "#FF7F00")) -> UILabel {
        let label = UILabel.creatLabel(title, font, titleColor, .center)
        label.setCornerRadiusAddBorder(cornerRadius, borderWidth, boderColor.cgColor)
        return label
    }
}
