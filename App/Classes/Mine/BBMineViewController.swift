//
//  BBMineViewController.swift
//  App
//
//  Created by zerry on 2022/4/1.
//

import UIKit
import Common

class BBMineViewController: BBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "gear"), style: .done, target: self, action: #selector(setting))
        
        let view = BBCommon.moduleApp.getView(builder: .create(name: "A", moduleData: "AAA")) ?? UIView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)
        view.center = self.view.center
        self.view.addSubview(view)
    }
    
    @objc
    func setting() {
        let con = BBMineSettingViewController.init()
        self.navigationController?.pushViewController(con, animated: true)
    }

}
