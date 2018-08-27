//
//  AppDelegate.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow
import DropDown
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    
    lazy var appServices: AppServices = {
        return AppServices()
    }()
    
    var window: UIWindow?
    var coordinator = Coordinator()
    var appFlow: AppFlow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let window = self.window else { return false}
        
        coordinator.rx.didNavigate.subscribe(onNext:{ (flow, step) in
            print("did navigation to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)
        
        self.appFlow = AppFlow(withWindow: window, services: self.appServices)
        
        coordinator.coordinate(flow: self.appFlow, withStepper: OneStepper(withSingleStep: InHeartStep.firstScreen))
        
        DropDown.startListeningToKeyboard()

        return true
    }
}

struct AppServices: HasProductsService, HasModifyCartItemService {
    let `$`: Dependencies = Dependencies.sharedDependencies
    private let apiProvider = MoyaProvider<ApiManager>()
    let productsService: ProductsService
    let modifyCartItemService: ModifyCartItemService
    
    init() {
        self.productsService = ProductsService(`$`: `$`, provider: apiProvider)
        self.modifyCartItemService = ModifyCartItemService(`$`: `$`, provider: apiProvider)
    }
}

