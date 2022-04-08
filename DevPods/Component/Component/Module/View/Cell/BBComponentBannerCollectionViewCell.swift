//
//  BBComponentBannerCollectionViewCell.swift
//  Alamofire
//
//  Created by zerry on 2022/4/8.
//

import UIKit
import SnapKit

class BBComponentBannerCollectionViewCell: BBAutoSizeCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let label = UILabel.init()
        label.text = "Banner"
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(444).priority(.medium)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
