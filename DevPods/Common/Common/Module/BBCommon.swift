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
/// 组件控制器创建协议
protocol ModuleControllerBuilderProtocol {
    var moduleViewDidLoadBlock: BBCommon.CallBack.NullCallBack? {get set}
    var moduleData: Any? {get set}
    
}

public
/// 组件视图创建协议
protocol ModuleViewBuilderProtocol {
    var moduleData: Any? {get set}
    
}



public
/// 组件控制器/视图创建者
struct ModuleBuilder {
    public
    /// 控制器创建者
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
    
    public
    /// 视图创建者
    struct ViewBuilder: ModuleViewBuilderProtocol {
        public var name: String
        public var moduleData: Any?
        public var frame: CGRect?
        public var builder: ModuleViewBuilder?
        
        public
        static func register(name: String, builder: @escaping ModuleViewBuilder) -> ViewBuilder {
            return ViewBuilder(name: name, builder: builder)
        }
        
        public
        static func create(name: String, moduleData: Any? = nil, frame: CGRect? = nil) -> ViewBuilder {
            return ViewBuilder(name: name, moduleData: moduleData, frame: frame)
        }
    }
    
    public
    /// 视图创建者
    struct FuncBuilder {
        public var name: String
        public var params: Any?
        public var builder: ModuleFuncBuilder?
        
        public
        static func register(name: String, builder: @escaping ModuleFuncBuilder) -> FuncBuilder {
            return FuncBuilder(name: name, builder: builder)
        }
        
        public
        static func create(name: String, params: Any? = nil) -> FuncBuilder {
            return FuncBuilder(name: name, params: params)
        }
    }
    
    public typealias ModuleControllerBuilder = () -> UIViewController & ModuleControllerBuilderProtocol
    public typealias ModuleViewBuilder = (_ frame: CGRect? ) -> UIView & ModuleViewBuilderProtocol
    public typealias ModuleFuncBuilder = (_ params: Any? ) -> Any?
}

public
protocol ModuleRegister: NSObjectProtocol {
    static var bundle: Bundle { get set }
    
    var controllerBuilders: [ModuleBuilder.ControllerBuilder]? { get }
    
    var viewBuilders: [ModuleBuilder.ViewBuilder]? { get }
    
    var funcBuilders: [ModuleBuilder.FuncBuilder]? { get }
     
    
//    moduleControllerRegister()
//    List<GetPage>? bundleGetPageRegister() {

}

public
class ModuleApp: NSObject {
    public static var shared = ModuleApp()
    public var modulleRegisters: [ModuleRegister] = []
    public var controllerBuilderRegisters: [ModuleBuilder.ControllerBuilder] = []
    public var viewBuilderRegisters: [ModuleBuilder.ViewBuilder] = []
    public var funcBuilderRegisters: [ModuleBuilder.FuncBuilder] = []
    
    public func moduleRegister(register: ModuleRegister) {
        modulleRegisters.append(register)
    }
    public func register(controllerBuilder: ModuleBuilder.ControllerBuilder) {
        controllerBuilderRegisters.append(controllerBuilder)
    }
    public func register(viewBuilder: ModuleBuilder.ViewBuilder) {
        viewBuilderRegisters.append(viewBuilder)
    }
    public func register(funcBuilder: ModuleBuilder.FuncBuilder) {
        funcBuilderRegisters.append(funcBuilder)
    }
    
    func compareController(outBuilder: ModuleBuilder.ControllerBuilder, inBuilder: ModuleBuilder.ControllerBuilder) -> UIViewController?{
        if outBuilder.name == inBuilder.name{
            if let builder = inBuilder.builder {
                var con = builder()
                con.moduleViewDidLoadBlock = outBuilder.moduleViewDidLoadBlock
                con.moduleData = outBuilder.moduleData
                return con
            }
            return nil
        }
        return nil
    }
    
    public func getController(name: String) -> UIViewController {
        return getController(builder: ModuleBuilder.ControllerBuilder.create(name: name))
    }
    
    public func getController(builder: ModuleBuilder.ControllerBuilder) -> UIViewController {
        for builderRegister in controllerBuilderRegisters {
            if let con = compareController(outBuilder: builder, inBuilder: builderRegister){
                return con
            }
        }
        
        for register in modulleRegisters {
            for registerBuilder in register.controllerBuilders ?? [] {
                if let con = compareController(outBuilder: builder, inBuilder: registerBuilder){
                    return con
                }
            }
        }
        return UIViewController()
    }
    
    func compareView(outBuilder: ModuleBuilder.ViewBuilder, inBuilder: ModuleBuilder.ViewBuilder) -> UIView?{
        if outBuilder.name == inBuilder.name{
            if let _builder = inBuilder.builder {
                var view = _builder(outBuilder.frame)
                view.moduleData = outBuilder.moduleData
                return view
            }
            return nil
        }
        return nil
    }
    
    public func getView(name: String) -> UIView? {
        return getView(builder: .create(name: name))
    }
    
    public func getView(builder: ModuleBuilder.ViewBuilder) -> UIView? {
        for viewRegister in viewBuilderRegisters {
            if let view = compareView(outBuilder: builder, inBuilder: viewRegister){
                return view
            }
        }
        
        for register in modulleRegisters {
            for registerBuilder in register.viewBuilders ?? [] {
                if let view = compareView(outBuilder: builder, inBuilder: registerBuilder){
                    return view
                }
            }
        }
        
        return nil
    }
    
    func compareAction(outBuilder: ModuleBuilder.FuncBuilder, inBuilder: ModuleBuilder.FuncBuilder) -> Any?{
        if outBuilder.name == inBuilder.name{
            if let builder = inBuilder.builder {
                return builder(outBuilder.params)
            }
            return nil
        }
        return nil
    }
    
    @discardableResult
    public func action(name: String, params: Any? = nil) -> Any? {
        return action(builder: .create(name: name, params: params))
    }
    
    @discardableResult
    public func action(builder: ModuleBuilder.FuncBuilder) -> Any? {
        for funcRegister in funcBuilderRegisters {
            if let result = compareAction(outBuilder: builder, inBuilder: funcRegister){
                return result
            }
        }
        
        for register in modulleRegisters {
            for registerBuilder in register.funcBuilders ?? [] {
                if let result = compareAction(outBuilder: builder, inBuilder: registerBuilder){
                    return result
                }
            }
        }
        
        return nil
    }
}

//class <#name#>: <#super class#> {
//    <#code#>
//}
