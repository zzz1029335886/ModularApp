//
//  BView.swift
//  Alamofire
//
//  Created by zerry on 2023/5/8.
//

import UIKit
import Common

class BView: UIView,ModuleViewBuilderProtocol {
    var moduleData: Any?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let label = UILabel.init(frame: bounds)
        label.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        label.text = "BView"
        backgroundColor = .red
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
