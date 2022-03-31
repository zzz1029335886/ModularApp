//
//  BBTabBarController.swift
//  App
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import ModuleA
import Common

class BBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        add()
        add()
    }
    
    func add() {
        let moduleAViewCon = BBModuleAViewController.init()
        moduleAViewCon.title = "ModuleA"
        let con = BBBaseNavigationController.init(rootViewController: moduleAViewCon)
        
        add(controller: con)
        
        BBSpacingButton.init(frame: .zero)
//        BBSpacingButton.init(frame: .zero)
    }
    
    func add(controller: UIViewController) {
        var viewControllers = self.viewControllers ?? []
        viewControllers.append(controller)
        self.viewControllers = viewControllers
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
