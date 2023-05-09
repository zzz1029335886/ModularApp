//
//  AView.swift
//  Alamofire
//
//  Created by zerry on 2023/5/8.
//

import UIKit
import Common

class AView: UIView, ModuleViewBuilderProtocol {
    var moduleData: Any?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let label = UILabel.init(frame: bounds)
        label.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        label.text = "AView"
        

        backgroundColor = .red
        addSubview(label)
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction)))
    }
    
    @objc func clickAction()  {
        let res = BBCommon.moduleApp.action(name: "Custom")
        print(res)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
