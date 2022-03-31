//
//  BBModuleAViewController.swift
//  ModuleA
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Base

open
class BBModuleAViewController: BBBaseViewController {

    open
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton.init(type: .contactAdd)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = self.view.center
    }
    
    @objc
    func btnClick() {
        let con = BBModuleAViewController.init()
        self.navigationController?.pushViewController(con, animated: true)
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
