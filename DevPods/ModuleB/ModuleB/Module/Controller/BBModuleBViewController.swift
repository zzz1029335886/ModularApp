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
class BBModuleBViewController: BBBaseViewController, Common.ModuleControllerBuilderProtocol {
    public var moduleViewDidLoadBlock: Common.BBCommon.CallBack.NullCallBack?
    
    public var moduleData: Any?
    
    open
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ModuleB"
        
        let btn = UIButton.init()
        btn.setTitle("pushA", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = self.view.center
    }
    
    @objc
    func btnClick() {
        let con = BBCommon.moduleApp.getController(name: "A")
        navigationController?.pushViewController(con, animated: true)
    }

}
