//
//  BBSettingUploadImageTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/10/10.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import TZImagePickerController

class BBSettingUploadImageTableViewCell: BBSettingTopTitleTableViewCell {
    
    var uploadImageViewItem: BBSettingUploadImageViewItem?{
        didSet{
            guard let uploadImageViewItem = uploadImageViewItem else { return }
            
            imagesView.maxCount = uploadImageViewItem.maxCount
            imagesView.isBrowse = uploadImageViewItem.isBrowse
            imagesView.setimageUrls(uploadImageViewItem.imageUrls)

        }
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        self.uploadImageViewItem = item as? BBSettingUploadImageViewItem
    }
    
    let imagesView = BBPublishImagesView()
    
    var selectedAssets : [Any] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imagesView.delegate = self
        contentView.addSubview(imagesView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func displayed() {
        super.displayed()
        
        guard let uploadImageViewItem = uploadImageViewItem else { return }
        let padding : CGFloat = 10
        let x = uploadImageViewItem.isBottom ? uploadImageViewItem.titleLabelPadding : titleLabel.frame.maxX - padding
        let y = uploadImageViewItem.isBottom ? titleLabel.frame.maxY : titleLabel.frame.minY - padding
        
        var width = contentView.frame.width - x - uploadImageViewItem.titleLabelPadding
        if let rightView = uploadImageViewItem.rightView{
            width = rightView.frame.minX - x - uploadImageViewItem.rightViewLeftPadding
        }
        
        let cellHeight = uploadImageViewItem.contentHeight ?? uploadImageViewItem.height ?? 44
        
        imagesView.frame = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: cellHeight - y)
    }
    
}

extension BBSettingUploadImageTableViewCell: BBPublishImagesViewDelegate, TZImagePickerControllerDelegate{
    func imagePickerController(_ picker: TZImagePickerController!,
                               didFinishPickingPhotos photos: [UIImage]!,
                               sourceAssets assets: [Any]!,
                               isSelectOriginalPhoto: Bool,
                               infos: [[AnyHashable : Any]]!) {
        
        let images = photos.compactMap { (image) -> (UIImage, String?) in
            return (image, nil)
        }
        
        self.selectedAssets = assets
        self.uploadImageViewItem?.imageUrls = images
        self.imagesView.setimageUrls(images)
    }
    
    func publishImagesViewAddClick(_ view: BBPublishImagesView) {
        guard let uploadImageViewItem = uploadImageViewItem else { return }
        guard let controller = controller else { return }
        guard let imagePickerVc = TZImagePickerController.init(maxImagesCount: uploadImageViewItem.maxCount, delegate: self) else { return }
        imagePickerVc.selectedAssets = selectedAssets.mutableArray
        controller.present(imagePickerVc, animated: true, completion: nil)
    }
    
    func publishImagesViewFrameChanged(_ view: BBPublishImagesView, changedHeight: CGFloat) {
        guard let uploadImageViewItem = uploadImageViewItem else { return }
        let defaultHeight = uploadImageViewItem.isBottom ? view.frame.origin.y : 44
        let height = uploadImageViewItem.contentHeight ?? uploadImageViewItem.height ?? defaultHeight
        
        updateContentHeight(max(height + changedHeight, defaultHeight))
    }
    
    func publishImagesView(_ view: BBPublishImagesView, suggestHeight: CGFloat) {
        
    }
    
    func publishImagesViewRemoved(_ view: BBPublishImagesView, index: Int) {
        self.uploadImageViewItem?.imageUrls.remove(at: index)
        self.selectedAssets.remove(at: index)
    }
    
    func updateContentHeight(_ height: CGFloat) {
        if uploadImageViewItem?.contentHeight == height {
            return
        }
        
        uploadImageViewItem?.contentHeight = height
        self.superTableView()?.beginUpdates()
        self.displayed()
        self.superTableView()?.endUpdates()
    }
}
