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
import ModuleAB
import Component

class BBTabBarController: UITabBarController {
    let moduleAViewCon = BBCommon.moduleApp.getController(name: "A")
    let moduleBViewCon = BBCommon.moduleApp.getController(name: "B")
    let moduleABViewCon = BBModuleABViewController.init()
    let mineViewCon = BBMineViewController.init()
    let componentCon = BBComponentViewController.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addModuleAB()
        addModuleComponent()
        addMine()
        addModuleA()
        addModuleB()
    }
    
    func addModuleAB() {
        moduleABViewCon.title = "ModuleAB"
        let con = BBBaseNavigationController.init(rootViewController: moduleABViewCon)
        add(controller: con)
    }
    
    func addModuleComponent() {
        componentCon.title = "Component"
        let con = BBBaseNavigationController.init(rootViewController: componentCon)
        add(controller: con)
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
