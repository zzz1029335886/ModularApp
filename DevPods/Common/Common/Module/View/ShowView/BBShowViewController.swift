//
//  BBShowViewController.swift
//  BrainBank
//
//  Created by zerry on 2021/3/30.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

class BBShowViewController: NSObject {
    static var showedSet = Set<BBShowViewController>()
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    weak var controller: UIViewController?
    weak var presentController: UIViewController?
    var tag = 0
    
    func show(_ controller: UIViewController,
              presentController: UIViewController,
              direction: PresentationDirection = .bottom())
    {
        self.controller = controller
        self.presentController = presentController
        
        slideInTransitioningDelegate.disableCompactHeight = false
        slideInTransitioningDelegate.direction = direction
        presentController.transitioningDelegate = slideInTransitioningDelegate
        presentController.modalPresentationStyle = .custom
        controller.present(presentController, animated: true, completion: nil)
    }
    
    func hide(_ animated: Bool = true) {
        presentController?.dismiss(animated: animated, completion: nil)
    }
    
}

extension BBShowViewController {
    class
    func show(_ controller: UIViewController,
              presentController: UIViewController,
              direction: PresentationDirection = .bottom()){
        let showViewCon = BBShowViewController()
        showViewCon.show(controller, presentController: presentController, direction: direction)
        showViewCon.tag = showedSet.count
        showedSet.insert(showViewCon)
    }
    
    class
    func hide(_ animated: Bool = true) {
        let arr = showedSet.sorted{$0.tag < $1.tag}
        arr.last?.hide()
    }
}
