//
//  BBMineViewController.swift
//  App
//
//  Created by zerry on 2022/4/1.
//

import UIKit
import Base

class BBMineViewController: BBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "gear"), style: .done, target: self, action: #selector(setting))
    }
    
    @objc
    func setting() {
        let con = BBMineSettingViewController.init()
        self.navigationController?.pushViewController(con, animated: true)
    }

}
