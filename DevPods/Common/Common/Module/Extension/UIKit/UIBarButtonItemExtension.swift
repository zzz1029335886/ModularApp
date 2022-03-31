//
//  UIBarButtonItemExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/5/10.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

@objc
class UIBarButtonItemShadowButton: UIButton {
    @objc
    var shadowOpacity = Float.zero{
        didSet{
            guard let layer = imageView?.layer else { return }
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @objc
    var shadowRadius = CGFloat.zero{
        didSet{
            guard let layer = imageView?.layer else { return }
            layer.shadowRadius = shadowRadius
        }
    }
    
    @objc
    var shadowOffset = CGSize.zero{
        didSet{
            guard let layer = imageView?.layer else { return }
            layer.shadowOffset = shadowOffset
        }
    }
    
    @objc
    var shadowColor = UIColor.black.cgColor{
        didSet{
            guard let layer = imageView?.layer else { return }
            layer.shadowColor = shadowColor
        }
    }
    
    @objc
    func setShadow(
        shadowOpacity: Float = 1,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGSize = .zero,
        shadowColor: CGColor = UIColor.black.cgColor
    ) {
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: -5)
        imageView?.clipsToBounds = false
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func setImage(_ image: UIImage?, color: UIColor, for state: UIControl.State) {
        let _image = image?.rechange(color: color, dimension: nil)
        setImage(_image, for: state)
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected {
                imageView?.layer.shadowColor = UIColor.clear.cgColor
            } else {
                imageView?.layer.shadowColor = shadowColor
            }
        }
    }
}

extension UIBarButtonItem{
    
    convenience init(
        buttonImage: UIImage?,
        title: String? = nil,
        titleColor: UIColor = .black,
        titleFont: UIFont = .systemFont(ofSize: 15),
        target: Any?,
        action: Selector
    ) {
        let button = BBSpacingButton.init()
        button.setImage(buttonImage, for: .normal)
        button.bb_setTitle(title, titleColor: titleColor, titleFont: titleFont)
        button.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: button)
    }
    
    convenience init(
        image: UIImage?,
        normalColor: UIColor = UIColor.white,
        selectedColor: UIColor = .black,
        shadowOpacity: Float = 1,
        shadowRadius: CGFloat = 5,
        shadowOffset: CGSize = .zero,
        shadowColor: CGColor = UIColor.black.cgColor,
        target: Any?,
        action: Selector
    ) {
        let button = UIBarButtonItemShadowButton.init()
        button.frame = .init(x: 0, y: 0, width: 41, height: 44)
        
        button.setImage(image, color: normalColor, for: .normal)
        button.setImage(image, color: selectedColor, for: .selected)
        
        button.setShadow(shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, shadowOffset: shadowOffset, shadowColor: shadowColor)
        button.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: button)
    }
    
    var shadowButton: UIBarButtonItemShadowButton?{
        return self.customView as? UIBarButtonItemShadowButton
    }
}
