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
class BBModuleBViewController: BBBaseViewController, ModuleControllerBuilderProtocol {
    public var moduleViewDidLoadBlock: BBCommon.CallBack.NullCallBack?
    
    public var moduleData: Any?
    
    open
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ModuleB"
        
        let aView = BBCommon.moduleApp.getView(builder: ModuleBuilder.ViewBuilder.create(name: "A",frame: .init(x: 0, y: 0, width: 100, height: 100))) ?? UIView()
        
        aView.center = .init(x: self.view.center.x, y: self.view.center.y - 100)
        
        self.view.addSubview(aView)
        
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
