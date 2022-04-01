//
//  BBSettingImageViewTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit

class BBSettingImageViewTableViewCell: BBSettingTitleTableViewCell {

    var iconImageView: UIImageView!
    var iconImageViewItem: BBSettingImageViewItem?{
        didSet{
            guard let iconImageViewItem = iconImageViewItem else { return }
            
            if let image = iconImageViewItem.image {
                iconImageView.image = image
                iconImageView.isUserInteractionEnabled = true
            } else if let url = iconImageViewItem.imageUrl{
                iconImageView.dn_setImage(url)
                iconImageView.isUserInteractionEnabled = url.count > 0
            }else{
                iconImageView.isUserInteractionEnabled = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: "bg_placeholder")
        iconImageView.tag = 1993
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageViewClick)))
        contentView.addSubview(iconImageView)
    }
    
    @objc func imageViewClick(){
        if iconImageView.image == nil { return }
//        PhotoBrowser.show(delegate: self, originPageIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if item is BBSettingImageViewItem {
            self.iconImageViewItem = item as? BBSettingImageViewItem
            
            
        }
    }
    
    override func displayed() {
        super.displayed()
        
        guard let iconImageViewItem = iconImageViewItem else { return }
        
        let padding = iconImageViewItem.imagePadding
        let iconImageViewWidth = contentView.frame.height - 2 * padding

        iconImageView.frame = CGRect(x: contentView.frame.width - iconImageViewWidth, y: padding, width: iconImageViewWidth, height: iconImageViewWidth)
        
        if iconImageViewItem.isRound {
            iconImageView.layer.cornerRadius = iconImageViewWidth * 0.5
            iconImageView.clipsToBounds = true
        }
        
    }

}

//extension BBSettingImageViewTableViewCell:PhotoBrowserDelegate,BBSaveImageProtocol{
//    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
//        return self.iconImageView
//    }
//    
//    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
//        return self.iconImageView.image
//    }
//    
//    func photoBrowser(_ photoBrowser: PhotoBrowser, localImageForIndex index: Int) -> UIImage? {
//        return self.iconImageView.image
//    }
//    
//    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
//        return 1
//    }
////    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
////        self.saveImageProtocol(image: image)
////    }
//}
