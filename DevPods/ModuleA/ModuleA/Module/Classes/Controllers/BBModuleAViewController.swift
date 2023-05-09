//
//  BBModuleAViewController.swift
//  ModuleA
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Base
import Common

class BBModuleAViewController: BBBaseViewController, Common.ModuleControllerBuilderProtocol {
    var moduleData: Any?
    
    var moduleViewDidLoadBlock: Common.BBCommon.CallBack.NullCallBack?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarInColor = .random
        view.backgroundColor = rgba(222, 222, 222, 1)
        title = "ModuleA"
        
        let imageBtn = UIButton.init()
        
        /// 加载组件图片
        let image = UIImage.init(inModuleNamed: "play_icon")
        imageBtn.setImage(image, for: .normal)
        imageBtn.addTarget(self, action: #selector(iconClick), for: .touchUpInside)
        imageBtn.tintColor = .systemBlue
        imageBtn.frame.size = .init(width: 44, height: 44)
        self.view.addSubview(imageBtn)
        imageBtn.center = self.view.center
        
        let btn = UIButton.init()
        btn.setTitle("pushB", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = .init(x: self.view.center.x, y: self.view.center.y + 100)
        
//        var AView.init()
    }
    
    @objc
    func btnClick() {
        let con = BBCommon.moduleApp.getController(name: "B")
        navigationController?.pushViewController(con, animated: true)
    }
    
    @objc
    func iconClick() {
        
        let path = BBModuleA.bundle.path(forResource: "Reader", ofType: "pdf")
        guard let path = path else { return }
        let url: URL = .init(fileURLWithPath: path)
        let con = UIDocumentInteractionController.init(url: url)
        con.delegate = self
        con.presentPreview(animated: true)
        
    }

}

extension BBModuleAViewController: UIDocumentInteractionControllerDelegate{
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
