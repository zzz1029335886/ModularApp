//
//  ModuleABViewController.swift
//  ModuleAB
//
//  Created by zerry on 2022/4/7.
//

import UIKit
import Base
import ModuleA
import ModuleB

open
class BBModuleABViewController: BBBaseViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton.init()
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.setTitle("Push ModuleA", for: .normal)
        btn.sizeToFit()
        btn.center = self.view.center
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        let pushBBtn = UIButton.init()
        pushBBtn.setTitleColor(.systemBlue, for: .normal)
        pushBBtn.setTitle("Push ModuleB", for: .normal)
        pushBBtn.sizeToFit()
        pushBBtn.center = .init(x: btn.center.x, y: btn.center.y + 44)
        self.view.addSubview(pushBBtn)
        pushBBtn.addTarget(self, action: #selector(pushBBtnClick), for: .touchUpInside)
    }
    
    @objc
    func btnClick() {
//        let con = BBModuleAViewController()
//        self.navigationController?.pushViewController(con, animated: true)
    }
    
    @objc
    func pushBBtnClick() {
        let con = BBModuleBViewController()
        self.navigationController?.pushViewController(con, animated: true)
    }

}
