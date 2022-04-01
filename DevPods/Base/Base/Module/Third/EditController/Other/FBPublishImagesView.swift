////
////  FBPublishImagesView.swift
////  FreshAllTime
////
////  Created by zerry on 2018/7/26.
////  Copyright © 2018年 蜡笔小姜和畅畅. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import AVFoundation
//import MobileCoreServices
//
//struct FBPublishImagesViewModel {
//    var image:UIImage?
//    var url:URL?
//}
//
//protocol FBPublishImagesViewDelegate:class {
//    func publishImagesViewAddClick(_ view:FBPublishImagesView)
//    func publishImagesViewFrameChanged(_ view:FBPublishImagesView,changedHeight:CGFloat)
//    func publishImagesViewAdded(_ view:FBPublishImagesView,image:QQGetPhotoListPhoto,url:URL?,index:Int)
//    func publishImagesListViewAdded(_ view:FBPublishImagesView,images:[QQGetPhotoListPhoto])
//    func publishImagesViewRemoved(_ view:FBPublishImagesView,index:Int)
//}
//
//extension FBPublishImagesViewDelegate{
//    func publishImagesViewAddClick(_ view:FBPublishImagesView){}
//    func publishImagesViewFrameChanged(_ view:FBPublishImagesView,changedHeight:CGFloat){}
//    func publishImagesViewAdded(_ view:FBPublishImagesView,image:QQGetPhotoListPhoto,url:URL?,index:Int){}
//    func publishImagesListViewAdded(_ view:FBPublishImagesView,images:[QQGetPhotoListPhoto]){}
//    func publishImagesViewRemoved(_ view:FBPublishImagesView,index:Int){}
//}
//
//class FBPublishImagesView: UIView {
//    weak var delegate : FBPublishImagesViewDelegate?
//    var collectionView : UICollectionView!
//    var layout : UICollectionViewFlowLayout!
//
//    var images : [(QQGetPhotoListPhoto?,PHAsset?)] = []
//    var imageAssetVideos : [(QQGetPhotoListPhoto?,PHAsset?,URL?)] = []
//
//    var maxCount = 9999
//    var countInLine = 3
//    var isEdit = true
//    var mediaTypes: [String] = ["public.image"]
//    var isPublish = false
//    var isCustomSelectImg = false
//    var isMultiple = false
//
//    var isHiddenDeleteButton : Bool?{
//        didSet{
//            self.collectionView.reloadData()
//        }
//    }
//    var isHiddenAddButton : Bool?{
//        didSet{
//            self.collectionView.reloadData()
//        }
//    }
//
//    weak var controller:UIViewController?
//    lazy var disposeBag = DisposeBag()
//
//    func setImageVideos(_ imageAssetVideos:[(QQGetPhotoListPhoto?,PHAsset?,URL?)]) {
//
//        //        self.imageVideos.removeAll()
//        //        self.images.removeAll()
//
//        self.imageAssetVideos = imageAssetVideos.filter({ (imageUrl) -> Bool in
//            return imageUrl.0 != nil || imageUrl.1 != nil || imageUrl.2 != nil
//        })
//
//        let images1 = imageAssetVideos.filter { (image,asset,url) -> Bool in
//            return (image != nil || asset != nil) && (url == nil)
//        }
//
//        self.images = images1.compactMap({ (image,asset,url) -> (QQGetPhotoListPhoto?,PHAsset?) in
//            return (image,asset)
//        })
//
//        self.resetFrame()
//        self.collectionView.reloadData()
//    }
//
//    static var temporaryVideoIndex = 0
//
//    func transformMoive(inputPath:String,outputPath:String){
//
//        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
//        //        let assetTime = avAsset.duration
//        //        let duration = CMTimeGetSeconds(assetTime)
//        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
//        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
//            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
//            let existBool = FileManager.default.fileExists(atPath: outputPath)
//            if existBool {
//                try? FileManager.default.removeItem(atPath: outputPath)
//            }
//            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
//
//            exportSession.outputFileType = AVFileType.mp4
//            exportSession.shouldOptimizeForNetworkUse = true;
//            //            MBProgressHUD.showLoading(toView: self.controller.view,message: "视频转码中")
//            _ = MBProgressHUD.showMessage("视频转码中")
//            exportSession.exportAsynchronously(completionHandler: {
//                //                ProgressHUD.hideLoading(toView: self.controller.view)
//                MBProgressHUD.hideMessage()
//
//                switch exportSession.status{
//
//                case .failed:
//                    //                    ProgressHUD.showMessage(message: "转码失败")
//                    MBProgressHUD.showText("转码失败")
//
//                    break
//                case .cancelled:
//                    //                    ProgressHUD.showMessage(message: "转码取消")
//                    MBProgressHUD.showText("转码失败")
//
//                    break;
//                case .completed:
//                    FBPublishImagesView.temporaryVideoIndex = FBPublishImagesView.temporaryVideoIndex + 1
//
//                    let mp4Path = URL.init(fileURLWithPath: outputPath)
//
//                    //                    if !self.getFileSize(filePath: outputPath){
//                    //                        MBProgressHUD.showText("视频太大或转码失败")
//                    //                        return
//                    //                    }
//
//                    //生成视频截图
//                    let generator = AVAssetImageGenerator(asset: avAsset)
//                    generator.appliesPreferredTrackTransform = true
//                    let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
//                    var actualTime:CMTime = CMTimeMake(value: 0,timescale: 0)
//                    let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
//                    let frameImg = UIImage.init(cgImage: imageRef)
////                    self.addImage(frameImg, url: mp4Path)
//                default:
//                    print("..")
//                    break;
//                }
//            })
//        }
//    }
//
//    func getFileSize(filePath:String) -> Bool {
//        let fileManager = FileManager.default
//        do {
//            let attr = try fileManager.attributesOfItem(atPath: filePath)
//            let size = attr[FileAttributeKey.size] as! UInt64
//            printLog("size = \(size)")
//
//            if size > 10 * 1024 * 1024 {
//                return false
//            }
//        } catch  {
//            return false
//        }
//
//        return true
//
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layout = UICollectionViewFlowLayout.init()
//        layout.minimumLineSpacing = 10
//
//        let width = (frame.width - (CGFloat(countInLine) - 1) * layout.minimumLineSpacing) / CGFloat(countInLine)
//
//        layout.itemSize = CGSize(width: width, height: width)
//
//        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        for _ in 0...maxCount {
//            collectionView.register(FBPublishImagesViewCell.self, forCellWithReuseIdentifier: "FBPublishImagesViewCell")
//        }
//
//        //        collectionView.register(FBPublishImagesViewCell.self, forCellWithReuseIdentifier: "FBPublishImagesViewCell")
//
//        addSubview(collectionView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//    }
//
//    func remove(_ image:String) {
//
//    }
//
//    func addImages(_ images:[(QQGetPhotoListPhoto?,PHAsset?)]) {
//        let imageUrls = images.compactMap { (image,asset) -> (QQGetPhotoListPhoto?,PHAsset?,URL?) in
//            return (image,asset,nil)
//        }
//        let insertIndex = self.images.count
//        let imageAssets = images.compactMap { (image,asset) -> (QQGetPhotoListPhoto?,PHAsset?) in
//            return (image,asset)
//        }
//        self.images.append(contentsOf: imageAssets)
//        self.imageAssetVideos.insert(contentsOf: imageUrls, at: insertIndex)
//
//        DispatchQueue.main.async {
//            self.collectionView.reloadSections(IndexSet.init(integer: 0))
//            if self.imageAssetVideos.count / self.countInLine != (self.imageAssetVideos.count - 1 ) / self.countInLine {
//                self.resetFrame()
//            }
//        }
//    }
//
//    func addAssets(_ assets:[PHAsset]) {
//
//        let imageUrls = assets.compactMap { asset -> (QQGetPhotoListPhoto?,PHAsset?,URL?) in
//            return (nil,asset,nil)
//        }
//        let insertIndex = self.images.count
//        let imageAssets = assets.compactMap { asset -> (QQGetPhotoListPhoto?,PHAsset?) in
//            return (nil,asset)
//        }
//        self.images.append(contentsOf: imageAssets)
//        self.imageAssetVideos.insert(contentsOf: imageUrls, at: insertIndex)
//
//        DispatchQueue.main.async {
//            self.collectionView.reloadSections(IndexSet.init(integer: 0))
//            if self.imageAssetVideos.count / self.countInLine != (self.imageAssetVideos.count - 1 ) / self.countInLine {
//                self.resetFrame()
//            }
//        }
//    }
//
//    //    func addImage(_ images:[String],index:Int = 0) {
//    //        if images.count == 0 || index >= images.count {
//    //            return
//    //        }
//    //
//    //        self.addImage(images[index], url: nil,isPost:false)
//    //
//    //        let index1 = index + 1
//    //
//    //        if index == images.count {
//    //            self.delegate?.publishImagesListViewAdded(self, images: images)
//    //            self.resetFrame(true)
//    //
//    //        }else{
//    //            self.addImage(images, index: index1)
//    //        }
//    //
//    //
//    //    }
//
//    func addImage(_ image:QQGetPhotoListPhoto,url:URL?) {
//        self.addImage(image, url: url, isPost: true)
//    }
//
//    func addImage(_ image:QQGetPhotoListPhoto,asset:PHAsset?,url:URL?,isPost:Bool?) {
//        if indexPath.row == imageAssetVideos.count && imageAssetVideos.count != maxCount{
//            var insertIndex = 0
//            if url == nil{
//                insertIndex = self.images.count
//                self.images.append((image,asset))
//            }else{
//                insertIndex = self.imageAssetVideos.count
//            }
//            self.imageAssetVideos.insert((image,asset,url), at: insertIndex)
//            //            self.imageVideos.append((image,url))
//
//            //            if indexPath.row + 1 < maxCount{
//            //                self.collectionView.insertItems(at: [IndexPath.init(row: insertIndex, section: 0)])
//            //            }
//
//            DispatchQueue.main.async {
//                self.collectionView.reloadSections(IndexSet.init(integer: 0))
//                if self.imageAssetVideos.count / self.countInLine != (self.imageAssetVideos.count - 1 ) / self.countInLine {
//                    self.resetFrame(isPost ?? true)
//                }
//            }
//
//            if isPost ?? true {
//                self.delegate?.publishImagesViewAdded(self, image: image, url: url,index:insertIndex)
//            }
//        }
//    }
//    func addImage(_ image:QQGetPhotoListPhoto,url:URL?,isPost:Bool?) {
//        self.addImage(image, asset: nil, url: url, isPost: isPost)
//    }
//
//    func resetFrame(_ isPost:Bool = true) {
//        if !isPost {
//            return
//        }
//
//        var flag = 0
//        if self.imageAssetVideos.count == self.maxCount {
//
//        }else{
//            flag = 1
//        }
//
//        let height = self.frame.size.height
//
//        self.frame.size.height = CGFloat(self.imageAssetVideos.count / self.countInLine + flag) * (self.layout.itemSize.height + self.layout.minimumLineSpacing)
//        let changedHeight = self.frame.height - height
//
//        if abs(changedHeight) < 10{
//            return
//        }
//
//        self.delegate?.publishImagesViewFrameChanged(self,changedHeight: self.frame.size.height - height)
//    }
//
//    var indexPath : IndexPath!
//}
//
//extension FBPublishImagesView:UICollectionViewDataSource,UICollectionViewDelegate,FBPublishImagesViewCellDelegate{
//    func cellVideoPlayButtonClick(indexPath: IndexPath, cell: FBPublishImagesViewCell) {
//        ZZVideoPlayer.play(urlString: self.imageAssetVideos[indexPath.row].2!.absoluteString,controller: self.controller)
//
//    }
//
//    func cellButtonClick(indexPath: IndexPath, cell: FBPublishImagesViewCell) {
//        self.indexPath = indexPath
//
//        if self.delegate != nil {
//            self.delegate?.publishImagesViewAddClick(self)
//        }
//
//        self.controller?.view.endEditing(true)
//    }
//
//    func cellImageViewButtonClick(indexPath: IndexPath, cell: FBPublishImagesViewCell) {
//        if indexPath.row < self.images.count {
//
//        } else {
//            ZZVideoPlayer.play(urlString: self.imageAssetVideos[indexPath.row].2!.absoluteString,controller: self.controller)
//        }
//    }
//
//    func cellDeleteButtonClick(indexPath: IndexPath, cell: FBPublishImagesViewCell) {
//        if indexPath.row <= imageAssetVideos.count && imageAssetVideos.count != 0{
//            if self.imageAssetVideos[indexPath.row].2 == nil{
//                self.images.remove(at: indexPath.row)
//            }
//            self.imageAssetVideos.remove(at: indexPath.row)
//            //            if indexPath.row < self.images.count{
//            //                self.collectionView.deleteItems(at: [indexPath])
//            //            }
//
//            self.collectionView.reloadSections(IndexSet.init(integer: 0))
//            self.delegate?.publishImagesViewRemoved(self, index: indexPath.row)
//
//            if self.imageAssetVideos.count / countInLine != (self.imageAssetVideos.count + 1 ) / countInLine {
//                self.resetFrame()
//            }
//
//
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var count = imageAssetVideos.count + 1
//        count = min(count, maxCount)
//
//        return count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FBPublishImagesViewCell", for: indexPath) as! FBPublishImagesViewCell
//        cell.indexPath = indexPath
//        cell.tag = 100 + indexPath.row
//        cell.delegate = self
//
//        if indexPath.row == self.imageAssetVideos.count{
//            cell.button.isHidden = false
//            cell.deleteButton.isHidden = true
//            cell.imageView.isHidden = true
//            cell.videoPlayButton.isHidden = true
//
//        }else{
//            cell.button.isHidden = true
//            cell.imageView.isHidden = false
//            cell.deleteButton.isHidden = false
//
//            let model = self.imageAssetVideos[indexPath.row]
//
//            if let image = model.0 {
//                cell.imageView.qq_setImage(urlStr: image.photoUrl)
//            }else if let asset = model.1 {
//                asset.fetchImage(CGSize.init(width: 200, height: 200)) { (image, info) in
//                    cell.imageView.image = image
//                }
//            }
//
//            if model.2 == nil{
//                cell.videoPlayButton.isHidden = true
//            }else{
//                cell.videoPlayButton.isHidden = false
//            }
//
//        }
//
//        if let hidden = self.isHiddenDeleteButton {
//            cell.deleteButton.isHidden = hidden
//        }
//
//        if let hidden = self.isHiddenAddButton {
//            cell.button.isHidden = hidden
//        }
//
//
//
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//}
//
//
//protocol FBPublishImagesViewCellDelegate : NSObjectProtocol{
//
//    func cellButtonClick(indexPath : IndexPath,cell:FBPublishImagesViewCell)
//    func cellDeleteButtonClick(indexPath : IndexPath,cell:FBPublishImagesViewCell)
//    func cellImageViewButtonClick(indexPath : IndexPath,cell:FBPublishImagesViewCell)
//    func cellVideoPlayButtonClick(indexPath : IndexPath,cell:FBPublishImagesViewCell)
//}
//
//class FBPublishImagesViewCell: UICollectionViewCell {
//    weak var delegate : FBPublishImagesViewCellDelegate?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    var imageView : UIImageView!
//    var button : UIButton!
//    var indexPath : IndexPath!
//    var deleteButton : UIButton!
//
//    var videoPlayButton:UIButton!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let padding = 10 as CGFloat
//        imageView = UIImageView.init(frame: CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding))
//        imageView.isUserInteractionEnabled = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageViewClick(_:))))
//        self.contentView.addSubview(imageView)
//
//        button = UIButton.init(frame: imageView.frame)
//        button.setImage(UIImage.init(named: "btn_add_img"), for: .normal)
//        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
//        self.contentView.addSubview(button)
//
//        deleteButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: padding * 2, height: padding * 2))
//        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
//        deleteButton.setImage(UIImage.init(named: "circle_delete"), for: .normal)
//        self.contentView.addSubview(deleteButton)
//
//        let playButtonWidth = imageView.frame.width * 0.5
//        let playButtonX = imageView.frame.minX + (imageView.frame.width - playButtonWidth) * 0.5
//        let playButtonY = imageView.frame.minY + (imageView.frame.height - playButtonWidth) * 0.5
//
//        videoPlayButton = UIButton.init(frame: CGRect(x:playButtonX, y: playButtonY, width: playButtonWidth, height: playButtonWidth))
//        videoPlayButton.setBackgroundImage(UIImage.init(named: "btn_play_b"), for: .normal)
//        videoPlayButton.addTarget(self, action: #selector(videoPlayButtonClick), for: UIControl.Event.touchUpInside)
//        self.contentView.addSubview(videoPlayButton)
//
//    }
//
//    @objc func buttonClick(){
//        if self.delegate != nil {
//            self.delegate?.cellButtonClick(indexPath: self.indexPath,cell: self)
//        }
//    }
//
//    @objc func deleteButtonClick(){
//        if self.delegate != nil {
//            self.delegate?.cellDeleteButtonClick(indexPath: self.indexPath,cell: self)
//        }
//    }
//
//    @objc func imageViewClick(_ ges:UIGestureRecognizer) {
//        if self.delegate != nil {
//            self.delegate?.cellImageViewButtonClick(indexPath: self.indexPath, cell: self)
//        }
//    }
//
//    @objc func videoPlayButtonClick() {
//        if self.delegate != nil {
//            self.delegate?.cellVideoPlayButtonClick(indexPath: self.indexPath, cell: self)
//        }
//    }
//
//}
//
