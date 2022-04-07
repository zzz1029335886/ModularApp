//
//  BBModuleAViewController.swift
//  ModuleA
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Base
import Common

open
class BBModuleAViewController: BBBaseViewController {
    
    public var pushBlock: BBCommon.CallBack.NullCallBack?
    
    open
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarInColor = .random
        view.backgroundColor = rgba(245, 245, 245, 1)
        title = "ModuleA"
        
        let btn = UIButton.init()
        
        /// 加载组件图片
        let image = UIImage.init(inModuleNamed: "play_icon")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.tintColor = .systemBlue
        btn.frame.size = .init(width: 44, height: 44)
        self.view.addSubview(btn)
        btn.center = self.view.center
        
    }
    
    @objc
    func btnClick() {
        if let pushBlock = pushBlock {
            pushBlock()
        }else{
//            .init(string: "https://invtest.nntest.cn/fp/Pj_EV98RTt2gGddvGE24TIn6PCvHnCTeScQGyVchKHNcHWCDxjkofCEY3KXuN3GhVkeWSVc7DYwDDQVZUAR8Jw.pdf")
            let path = BBModuleA.frameworkBundle.path(forResource: "Reader", ofType: "pdf")
            guard let path = path else { return }
            let url: URL = .init(fileURLWithPath: path)
            let con = UIDocumentInteractionController.init(url: url)
            con.delegate = self
//            con.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
            con.presentPreview(animated: true)
        }
    }

}

extension BBModuleAViewController: UIDocumentInteractionControllerDelegate{
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
