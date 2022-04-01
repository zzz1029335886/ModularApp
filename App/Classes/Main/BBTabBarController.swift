//
//  BBTabBarController.swift
//  App
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import ModuleA
import Common
import ModuleB

class BBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addModuleA()
        addModuleB()
        addMine()
    }
    
    func addModuleA() {
        let moduleAViewCon = BBModuleAViewController.init()
        moduleAViewCon.title = "ModuleA"
        let con = BBBaseNavigationController.init(rootViewController: moduleAViewCon)
        add(controller: con)
    }
    
    func addModuleB() {
        let moduleBViewCon = BBModuleBViewController.init()
        moduleBViewCon.title = "ModuleB"
        let con = BBBaseNavigationController.init(rootViewController: moduleBViewCon)
        add(controller: con)
    }
    
    
    func addMine() {
        let moduleBViewCon = BBMineViewController.init()
        moduleBViewCon.title = "Mine"
        let con = BBBaseNavigationController.init(rootViewController: moduleBViewCon)
        add(controller: con)
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
