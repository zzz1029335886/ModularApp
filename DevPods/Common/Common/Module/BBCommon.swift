//
//  BBCommon.swift
//  Common
//
//  Created by zerry on 2022/3/31.
//

import UIKit


public struct BBCommon {
    public static var moduleApp = ModuleApp.shared

    /**
     各种回调类型
     */
    public struct CallBack {
        public typealias NullCallBack = () -> Void
        public typealias DictionaryCallBack = (_ dict:Dictionary<String, Any>) -> Void
        public typealias AnyCallBack = (_ any:Any) -> Void
        public typealias URLCallBack = (_ url:URL) -> Void
        public typealias BoolURLCallBack = (_ bool:Bool,_ url:URL) -> Void
        public typealias BoolCallBack = (_ bool:Bool) -> Void
        public typealias BoolIntBack = (_ bool:Bool,_ int:Int) -> Void
        public typealias BoolStringCallBack = (_ bool:Bool,_ string:String) -> Void
        public typealias FloatCallBack = (_ float:CGFloat) -> Void
        public typealias IntCallBack = (_ int:Int) -> Void
        public typealias IntFloatCallBack = (_ int:Int, _ float:Float) -> Void
        public typealias StringArrayCallBack = (_ strings:[String]) -> Void
        public typealias StringCallBack = (_ strings:String) -> Void
        public typealias StringIntBack = (_ strings:String,_ int:Int) -> Void
    }
    
    // 屏幕宽度
    public static let kScreenWidth = UIScreen.main.bounds.size.width
    // 屏幕高度
    public static let kScreenHeight = UIScreen.main.bounds.size.height

    /**
     是否全面屏手机
     */
    public static let kIsFullScreen : Bool = {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else { return false }
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 { return true }
        }
        return false
    }()

    /**
     状态栏高度
     */
    public static let kStatusBarHeight : CGFloat = {
        var safeAreaTop : CGFloat = 20
        if #available(iOS 11, *) {
              if let w = UIApplication.shared.delegate?.window,
                let unwrapedWindow = w {
                safeAreaTop = unwrapedWindow.safeAreaInsets.top
              }
        }
        return safeAreaTop
    }()

    /**
     导航栏高度
     */
    public static let kNavigationBarHeight : CGFloat = kStatusBarHeight + 44

    /**
     曲面屏底部安全距离
     */
    public static let kBottomSafeHeight : CGFloat = {
        var safeAreaBottom : CGFloat = 0
        if #available(iOS 11, *) {
              if let w = UIApplication.shared.delegate?.window,
                 let unwrapedWindow = w {
                safeAreaBottom = unwrapedWindow.safeAreaInsets.bottom
              }
        }
        return safeAreaBottom
    }()

    public static let kTabBarHeight : CGFloat = kBottomSafeHeight + 49
}

public
protocol ModuleControllerBuilderProtocol {
    var moduleViewDidLoadBlock: BBCommon.CallBack.NullCallBack? {get set}
    var moduleData: Any? {get set}
    
}



public
struct ModuleBuilder {
    public
    struct ControllerBuilder: ModuleControllerBuilderProtocol {
        public var name: String
        
        
        public var moduleViewDidLoadBlock: BBCommon.CallBack.NullCallBack?
        public var moduleData: Any?
        
        public var builder: ModuleControllerBuilder?
        
        public
        static func register(name: String, builder: @escaping ModuleControllerBuilder) -> ControllerBuilder {
            return ControllerBuilder(name: name, builder: builder)
        }
        
        public
        static func create(name: String, moduleViewDidLoadBlock: BBCommon.CallBack.NullCallBack? = nil, moduleData: Any? = nil) -> ControllerBuilder {
            return ControllerBuilder(name: name, moduleViewDidLoadBlock: moduleViewDidLoadBlock, moduleData: moduleData)
        }
        
        
    }
    
    public typealias ModuleControllerBuilder = () -> UIViewController&ModuleControllerBuilderProtocol
    public typealias ModuleViewBuilder = () -> UIView

    public
    var controllerBuilders: [ControllerBuilder]?
    public
    var viewBuilders: [String: ModuleViewBuilder]?
    
    public
    init(controllerBuilders: [ControllerBuilder]? = nil,
         viewBuilders: [String: ModuleViewBuilder]? = nil) {
        self.controllerBuilders = controllerBuilders
        self.viewBuilders = viewBuilders
    }
}

public
protocol ModuleRegister: NSObjectProtocol {
    static var bundle: Bundle { get set }
    var register: ModuleBuilder { get }
     
    
//    moduleControllerRegister()
//    List<GetPage>? bundleGetPageRegister() {

}

public
class ModuleApp: NSObject {
    public static var shared = ModuleApp()
    public var modulleRegisters: [ModuleRegister] = []
    public var builderRegisters: [ModuleBuilder.ControllerBuilder] = []
    
    public func moduleRegister(register: ModuleRegister) {
        modulleRegisters.append(register)
    }
    
    public func builderRegister(builder: ModuleBuilder.ControllerBuilder) {
        builderRegisters.append(builder)
    }
    
    func compare(outBuilder: ModuleBuilder.ControllerBuilder, inBuilder: ModuleBuilder.ControllerBuilder) -> UIViewController?{
        if outBuilder.name == inBuilder.name{
            
            if let builder = inBuilder.builder {
                
                var con = builder()
                con.moduleViewDidLoadBlock = outBuilder.moduleViewDidLoadBlock
                con.moduleData = outBuilder.moduleData
                return con
            }
            
//            return UIViewController()
            
        }
        
        return nil
    }
    
    public func getController(name: String) -> UIViewController {
        return getController(builder: ModuleBuilder.ControllerBuilder.create(name: name))
    }
    
    public func getController(builder: ModuleBuilder.ControllerBuilder) -> UIViewController {
        for builderRegister in builderRegisters {
            if let con = compare(outBuilder: builder, inBuilder: builderRegister){
                return con
            }
        }
        
        for register in modulleRegisters {
            for registerBuilder in register.register.controllerBuilders ?? [] {
                if let con = compare(outBuilder: builder, inBuilder: registerBuilder){
                    return con
                }
            }
        }
        return UIViewController()
    }
    
    public func getView(name: String) -> UIView {
        for register in modulleRegisters {
            for builder in register.register.viewBuilders ?? [:] {
                if builder.key == name{
                    return builder.value()
                }
            }
        }
        
        return UIView()
    }
}

//class <#name#>: <#super class#> {
//    <#code#>
//}
