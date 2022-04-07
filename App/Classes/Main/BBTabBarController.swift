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
    let moduleAViewCon = BBModuleAViewController.init()
    let moduleBViewCon = BBModuleBViewController.init()
    let mineViewCon = BBMineViewController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMine()
        addModuleA()
        addModuleB()
    }
    
    func addModuleA() {
        moduleAViewCon.title = "ModuleA"
        let con = BBBaseNavigationController.init(rootViewController: moduleAViewCon)
        add(controller: con)
    }
    
    func addModuleB() {
        moduleBViewCon.title = "ModuleB"
        let con = BBBaseNavigationController.init(rootViewController: moduleBViewCon)
        add(controller: con)
    }
    
    
    func addMine() {
        mineViewCon.title = "Mine"
        let con = BBBaseNavigationController.init(rootViewController: mineViewCon)
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
