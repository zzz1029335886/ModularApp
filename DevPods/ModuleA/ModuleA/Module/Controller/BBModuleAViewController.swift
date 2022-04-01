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
        title = "ModuleA"
        
        let btn = UIButton.init(type: .contactAdd)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = self.view.center
    }
    
    @objc
    func btnClick() {
        if let pushBlock = pushBlock {
            pushBlock()
        }else{
            self.navigationController?.pushViewController(BBModuleAViewController.init(), animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
