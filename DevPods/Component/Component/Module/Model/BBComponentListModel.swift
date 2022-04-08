//
//  BBComponentListModel.swift
//  Alamofire
//
//  Created by zerry on 2022/4/8.
//

import UIKit
import IGListDiffKit
import IGListKit

class BBComponentListModel: NSObject, ListDiffable {
    
    enum ComponentType {
    case banner
    }
    
    var type: ComponentType = .banner
    
    let timestamp = Int(Date().timeIntervalSince1970) + Int(arc4random())

    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber.init(value: self.timestamp)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return (object as? BBComponentListModel)?.timestamp == self.timestamp
    }
    

}
