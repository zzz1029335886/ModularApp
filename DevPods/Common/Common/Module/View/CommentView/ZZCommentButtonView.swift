//
//  ZZCommentButtonView.swift
//  tdian
//
//  Created by zerry on 2019/8/26.
//  Copyright © 2019 zerry. All rights reserved.
//

import UIKit

class ZZCommentButtonView: ZZCommentView {
    var bgView = UIView()
    var button = UIButton()

    var buttonTitle : String?{
        didSet{
            guard let buttonTitle = buttonTitle else { return }
            self.button.setTitle(buttonTitle, for: UIControl.State.normal)
        }
    }
    init(frame: CGRect) {
        super.init(frame: frame, padding: 16, hasLine: true, isEffect: true)
        
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (m) in
            m.top.equalTo(self.snp.bottom)
            m.leading.equalToSuperview()
            m.trailing.equalToSuperview()
            m.height.equalTo(44)
        }
        
        textView.frame.size.width -= 60
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = rgba(213, 213, 213, 1).cgColor
        textView.backgroundColor = rgba(238, 238, 238, 1)
        
        self.backgroundColor = .white
        
        let width : CGFloat = 40
        let padding = (frame.width - textView.frame.maxX - width) * 0.5
        button.frame = CGRect(x: textView.frame.maxX + padding,
                              y: textView.frame.origin.y,
                              width: width,
                              height: frame.height - 2 * textView.frame.origin.y)
        button.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        button.setTitle("发送", for: UIControl.State.normal)
        button.bb_setTitleColor(.black)
        button.titleLabel?.font = .medium(14)
        addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
