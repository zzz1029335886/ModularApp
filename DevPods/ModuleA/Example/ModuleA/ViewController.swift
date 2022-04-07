//
//  ViewController.swift
//  ModuleA
//
//  Created by 张泽中 on 03/31/2022.
//  Copyright (c) 2022 张泽中. All rights reserved.
//

import UIKit
import Networking
import ModuleA
import ModuleB

class ViewController: BBModuleAViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(type: .contactAdd)
        button.setTitle("PageA", for: .normal)
        button.sizeToFit()
        self.view.addSubview(button)
        button.center = self.view.center
        button.center.y += 22
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    @objc
    func buttonClick() {
        let con = BBModuleBViewController()
        self.navigationController?.pushViewController(con, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

