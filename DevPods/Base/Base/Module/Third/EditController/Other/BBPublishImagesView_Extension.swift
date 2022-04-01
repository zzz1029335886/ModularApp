//
//  BBPublishImagesView_Extension.swift
//  qqncp
//
//  Created by zerry on 2018/11/12.
//  Copyright © 2018 zerry. All rights reserved.
//

import UIKit

//extension BBPublishImagesView: QQCaptureImageVideoViewControllerDelegate{
//    @available(iOS 10.0, *)
//    static var controller : QQCaptureImageVideoViewController?
//
//    @available(iOS 10.0, *)
//    func captureImageVideoViewControllerImage(_ controller: QQCaptureImageVideoViewController, image: UIImage) {
//        self.addImage(image, url: nil)
//
//        BBPublishImagesView.controller?.dismiss(animated: true, completion: {
//            BBPublishImagesView.controller = nil
//        })
//    }
//
//    @available(iOS 10.0, *)
//    func captureImageVideoViewControllerVideo(_ controller: QQCaptureImageVideoViewController, url: URL) {
//
//        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
//        let cachePath = cachePaths[0]
//        let outpath: String = "\(cachePath)/\(Date().timeIntervalSince1970).mp4"
//
//        DispatchQueue.main.async {
//            self.transformMoive(inputPath: url.path, outputPath: outpath)
//        }
//
//        BBPublishImagesView.controller?.dismiss(animated: true, completion: {
//            BBPublishImagesView.controller = nil
//        })
//    }
//
//    @available(iOS 10.0, *)
//    func takeAPicture() {
//        let controller = QQCaptureImageVideoViewController.init()
//        controller.delegate = self
//        BBPublishImagesView.controller = controller
//        self.controller?.present(controller, animated: true, completion: nil)
//    }
//}
