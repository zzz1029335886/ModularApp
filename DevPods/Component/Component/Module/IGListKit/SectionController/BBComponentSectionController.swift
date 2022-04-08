//
//  BBComponentSectionController.swift
//  Component
//
//  Created by zerry on 2022/4/8.
//

import UIKit

class BBComponentSectionController: BBListSectionController {
    var containerWidth: CGFloat{
        return collectionContext?.containerSize.width ?? UIScreen.main.bounds.width
    }
    
    var columnCountForSection: Int{
        return 1
    }
    
    var model: BBComponentListModel!
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        
        model = object as? BBComponentListModel
    }
}
