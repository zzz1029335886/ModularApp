//
//  BBComponentNormalSectionController.swift
//  Component
//
//  Created by zerry on 2022/4/8.
//

import UIKit

class BBComponentNormalSectionController: BBComponentSectionController {
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch model.type{
        case .banner:
            cell = dequeueAutoSizeReusableCell(of: BBComponentBannerCollectionViewCell.self, at: index)
        }
        
        return cell
        
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return super.sizeForItem(at: index)
    }
    
    override var columnCountForSection: Int {
        return 2
    }
    
}
