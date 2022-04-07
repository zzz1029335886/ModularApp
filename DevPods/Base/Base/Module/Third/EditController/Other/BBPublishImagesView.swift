//
//  BBPublishImagesView.swift
//  FreshAllTime
//
//  Created by zerry on 2018/7/26.
//  Copyright © 2018年 蜡笔小姜和畅畅. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import JXPhotoBrowser
import Common

/// 代理方法
protocol BBPublishImagesViewDelegate: AnyObject {
    
    /// 点击了添加按钮
    /// - Parameter view: 当前View
    func publishImagesViewAddClick(_ view: BBPublishImagesView)
    
    /// frame改变
    /// - Parameters:
    ///   - view: 当前view
    ///   - changedHeight: 改变的高度，负表示减少
    func publishImagesViewFrameChanged(_ view: BBPublishImagesView, changedHeight: CGFloat)
    
    /// 推荐高度
    /// - Parameters:
    ///   - view: 当前view
    ///   - suggestHeight: 推荐高度
    func publishImagesView(_ view: BBPublishImagesView, suggestHeight: CGFloat)

    
    /// 删除第几个
    /// - Parameters:
    ///   - view: 当前view
    ///   - index: 删除的位置
    func publishImagesViewRemoved(_ view: BBPublishImagesView, index: Int)
}

//extension BBPublishImagesViewDelegate{
//    func publishImagesViewAddClick(_ view:BBPublishImagesView){}
//    func publishImagesViewFrameChanged(_ view:BBPublishImagesView,changedHeight:CGFloat){}
//    func publishImagesViewAdded(_ view:BBPublishImagesView,image:UIImage,url:URL?,index:Int){}
//    func publishImagesListViewAdded(_ view:BBPublishImagesView,images:[UIImage]){}
//    func publishImagesViewRemoved(_ view:BBPublishImagesView,index:Int){}
//}

class BBPublishImagesView: UIView{
    weak var delegate : BBPublishImagesViewDelegate?
    weak var controller: UIViewController?

    lazy var layout = UICollectionViewFlowLayout()
    var collectionView : UICollectionView!

    var imageUrls : [(UIImage?, String?)] = []
    var maxCount = 9
    var countInLine = 3
    var isBrowse = false{
        didSet{
            if isBrowse {
                isHiddenAddButton = true
                isHiddenDeleteButton = true
            }else{
                isHiddenAddButton = nil
                isHiddenDeleteButton = nil
            }
        }
    }
    
    var isHiddenDeleteButton: Bool?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var isHiddenAddButton: Bool?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    func setimageUrls(_ imageUrls: [(UIImage?, String?)]) {
        self.imageUrls = imageUrls
        self.collectionView.reloadData()
    }
    
    init(frame: CGRect = .zero,
         countInLine: Int = 3,
         maxCount: Int = 9) {
        super.init(frame: frame)
        
        layout.minimumLineSpacing = 10
        
        self.maxCount = maxCount
        self.countInLine = countInLine
        
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        for index in 0...maxCount {
            collectionView.register(BBPublishImagesViewCell.self, forCellWithReuseIdentifier: "BBPublishImagesViewCell\(index)")
        }
        
        //        collectionView.register(BBPublishImagesViewCell.self, forCellWithReuseIdentifier: "BBPublishImagesViewCell")
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func addImages(_ images: [UIImage]) {
        let imageUrls = images.compactMap { image -> (UIImage?, String?) in
            return (image, nil)
        }
        self.imageUrls.append(contentsOf: imageUrls)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func addImage(_ image: UIImage, url: String?) {
        
        if indexPath.row == imageUrls.count && imageUrls.count != maxCount{
            self.imageUrls.append((image,url))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func resetFrame() {
        
        var flag = 0
        if self.imageUrls.count != self.maxCount {
            flag = 1
        }
        
        let height = self.frame.size.height
        let size = self.collectionView(collectionView, layout: layout, sizeForItemAt: IndexPath())
        
        let lineCount = CGFloat(self.imageUrls.count / self.countInLine + flag)
        self.frame.size.height = max(1, lineCount) * (size.height + self.layout.minimumLineSpacing) - self.layout.minimumLineSpacing
        self.delegate?.publishImagesView(self, suggestHeight: self.frame.height)
        
        let changedHeight = self.frame.height - height
        if abs(changedHeight) < 1 {
            return
        }
        
        self.delegate?.publishImagesViewFrameChanged(self, changedHeight: changedHeight)
    }
    
    var indexPath = IndexPath()
}

extension BBPublishImagesView:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    BBPublishImagesViewCellDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - (CGFloat(countInLine) - 1) * layout.minimumLineSpacing) / CGFloat(countInLine)
        let itemSize = CGSize(width: width, height: width)
        return itemSize
    }
    
    func cellVideoPlayButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell) {
        
    }
    
    func cellButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell) {
        self.indexPath = indexPath
        self.delegate?.publishImagesViewAddClick(self)
        self.controller?.view.endEditing(true)
    }
    
    func cellImageViewButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell) {
        if indexPath.row < self.imageUrls.count {
            let browser = JXPhotoBrowser()
            browser.numberOfItems = {
                self.imageUrls.count
            }
            
            browser.reloadCellAtIndex = { context in
                guard let browserCell = context.cell as? JXPhotoBrowserImageCell else {
                    return
                }
                browserCell.index = context.index
                
                let imageUrl = self.imageUrls[context.index]
                if let image = imageUrl.0 {
                    browserCell.imageView.image = image
                }else if let url = imageUrl.1{
                    browserCell.imageView.dn_setImage(url)
                }
                
            }
            
            browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
            browser.pageIndex = indexPath.row
            browser.show()
        }
    }
    
    func cellDeleteButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell) {
        if indexPath.row <= imageUrls.count && imageUrls.count != 0{
            self.imageUrls.remove(at: indexPath.row)
            self.collectionView.reloadData()
            self.delegate?.publishImagesViewRemoved(self, index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = imageUrls.count + 1
        count = min(count, maxCount)
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BBPublishImagesViewCell\(indexPath.row)", for: indexPath) as! BBPublishImagesViewCell
        cell.indexPath = indexPath
        cell.tag = 100 + indexPath.row
        cell.delegate = self
        
        if indexPath.row == 0 {
            resetFrame()
        }
        
        if indexPath.row == self.imageUrls.count{
            cell.button.isHidden = false
            cell.deleteButton.isHidden = true
            cell.imageView.isHidden = true
        }else{
            cell.button.isHidden = true
            cell.imageView.isHidden = false
            cell.deleteButton.isHidden = false
            
            let model = self.imageUrls[indexPath.row]
            if let image = model.0 {
                cell.imageView.image = image
            }else if let url = model.1{
                cell.imageView.dn_setImage(url)
            }
        }
        
        if let hidden = self.isHiddenDeleteButton {
            cell.deleteButton.isHidden = hidden
        }
        
        if let hidden = self.isHiddenAddButton {
            cell.button.isHidden = hidden
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

protocol BBPublishImagesViewCellDelegate : NSObjectProtocol{
    func cellButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell)
    func cellDeleteButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell)
    func cellImageViewButtonClick(indexPath: IndexPath, cell: BBPublishImagesViewCell)
}

class BBPublishImagesViewCell: UICollectionViewCell {
    weak var delegate : BBPublishImagesViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var imageView : UIImageView!
    var button : UIButton!
    var indexPath : IndexPath!
    var deleteButton : UIButton!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let padding = 10 as CGFloat
        imageView = UIImageView.init(frame: CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageViewClick(_:))))
        self.contentView.addSubview(imageView)
        
        button = UIButton.init(frame: imageView.frame)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.contentView.addSubview(button)
        
        deleteButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: padding * 2, height: padding * 2))
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        self.contentView.addSubview(deleteButton)
        
        if #available(iOS 13.0, *) {
            button.tintColor = .darkGray
            button.setImage(UIImage.init(systemName: "plus.square.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 44)), for: .normal)
            deleteButton.setImage(UIImage.init(systemName: "minus.circle.fill"), for: .normal)
            deleteButton.tintColor = .systemRed
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func buttonClick(){
        self.delegate?.cellButtonClick(indexPath: self.indexPath, cell: self)
    }
    
    @objc func deleteButtonClick(){
        self.delegate?.cellDeleteButtonClick(indexPath: self.indexPath, cell: self)
    }
    
    @objc func imageViewClick(_ ges:UIGestureRecognizer) {
        self.delegate?.cellImageViewButtonClick(indexPath: self.indexPath, cell: self)
    }
}

