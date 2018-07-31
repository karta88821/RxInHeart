//
//  AppFlow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxFlow
import ESTabBarController_swift

class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    
    init(withWindow window: UIWindow) {
        self.rootWindow = window
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? InHeartStep else { return NextFlowItems.none }
        switch step {
        case .firstScreen:
            return navigationToTabbarScreen()
        default:
            return NextFlowItems.none
        }
    }
    
    // 移至ESTabbarController
    private func navigationToTabbarScreen() -> NextFlowItems {
        let esTabbarController = ESTabBarController()
        let selectedStepper = SelectedStepper()
        let accountStepper = AccountStepper()
        let selectedFlow = SelectedFlow(with: selectedStepper)
        let accountFlow = AccountFlow(with: accountStepper)
        
        Flows.whenReady(flow1: selectedFlow, flow2: accountFlow, block: { [unowned self] (root1: UINavigationController, root2: UINavigationController) in
            let esTabbarItem1 = ESTabBarItem.init(ExampleBasicContentView(),title: "商品", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            let esTabbarItem2 = ESTabBarItem.init(ExampleBasicContentView(),title: "會員", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
            root1.tabBarItem = esTabbarItem1
            root1.navigationBar.isTranslucent = false
            root1.navigationBar.makeShadow()
            
            root2.tabBarItem = esTabbarItem2
            root2.navigationBar.isTranslucent = false
            root2.navigationBar.makeShadow()

            esTabbarController.setViewControllers([root1, root2], animated: false)
            esTabbarController.tabBar.makeShadow()

            self.rootWindow.rootViewController = esTabbarController
        })
        
        return NextFlowItems.multiple(flowItems: [NextFlowItem(nextPresentable: selectedFlow, nextStepper: selectedStepper),NextFlowItem(nextPresentable: accountFlow, nextStepper: accountStepper)])
    }
    
}
