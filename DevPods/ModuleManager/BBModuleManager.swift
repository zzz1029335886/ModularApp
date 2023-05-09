//
//  BBModuleManager.swift
//  Alamofire
//
//  Created by zerry on 2023/5/8.
//

public struct BBModuleManager {
    public typealias NullCallBack = () -> Void

}

public
protocol ModuleControllerBuilderProtocol {
    var moduleViewDidLoadBlock: BBModuleManager.NullCallBack? {get set}
    var moduleData: Any? {get set}
    
}



public
struct ModuleBuilder {
    public
    struct ControllerBuilder: ModuleControllerBuilderProtocol {
        public var name: String
        
        
        public var moduleViewDidLoadBlock: BBModuleManager.NullCallBack?
        public var moduleData: Any?
        
        public var builder: ModuleControllerBuilder?
        
        public
        static func register(name: String, builder: @escaping ModuleControllerBuilder) -> ControllerBuilder {
            return ControllerBuilder(name: name, builder: builder)
        }
        
        public
        static func create(name: String, moduleViewDidLoadBlock: BBModuleManager.NullCallBack? = nil, moduleData: Any? = nil) -> ControllerBuilder {
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
