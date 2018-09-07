//
//  InfoDetailFlow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/8.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow
import UIKit

class InfoDetailFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let infoDetailStepper: InfoDetailStepper
    
    init(with stepper: InfoDetailStepper) {
        self.infoDetailStepper = stepper
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? InHeartStep else { return NextFlowItems.none }
        
        switch step {
        case .infoDetail:
            return navigateToAddressScreen()
        case .dismissInfo:
            return NextFlowItems.end(withStepForParentFlow: InHeartStep.dismissInfo)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToAddressScreen() -> NextFlowItems {
        let viewModel = InfoDetailViewModel()
        let viewController = InfoDetailViewController()
        viewController.viewModel = viewModel
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self.infoDetailStepper, action: #selector(InfoDetailStepper.dismiss))
            navigationBarItem.setLeftBarButton(button, animated: true)
        }
        return NextFlowItems.none
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
}

class InfoDetailStepper: Stepper, HasDisposeBag {
    init() {
        self.step.accept(InHeartStep.infoDetail)
    }
    
    @objc func dismiss() {
        self.step.accept(InHeartStep.dismissInfo)
    }
}
