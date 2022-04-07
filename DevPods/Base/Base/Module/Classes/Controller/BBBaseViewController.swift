//
//  BBBaseViewController.swift
//  Base
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import SnapKit

open class BBBaseViewController: UIViewController, RainbowColorSource {
    lazy var rainbowNavigation = RainbowNavigation()
    var snpSafeAreaTop : ConstraintItem{
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.snp.top
        } else {
            return self.topLayoutGuide.snp.top
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if self.navigationController?.viewControllers.first == self {
            if let navigationController = navigationController {
                rainbowNavigation.wireTo(navigationController: navigationController)
            }
        }else{
            
        }
    }
    
    public var navigationBarInSimilarColor: UIColor?
    public var navigationBarInColor: UIColor = .white{
        didSet{
            navigationController?.navigationBar.rb.backgroundColor = navigationBarInColor
        }
    }
    
    var isNavigationBarHidden: Bool = false{
        didSet{
            setNavigationBarHidden()
            if isNavigationBarHidden {
                navigationBarInColor = .init(white: 1, alpha: 0)
            } else {
                navigationBarInColor = .white
            }
        }
    }
    
    func setNavigationBarHidden() {
        
        guard self.parent is UINavigationController else {
            return
        }
        self.navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
