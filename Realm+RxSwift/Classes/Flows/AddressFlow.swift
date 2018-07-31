//
//  AddressFlow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow
import UIKit

class AddressFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let addressStepper: AddressStepper
    
    init(with stepper: AddressStepper) {
        self.addressStepper = stepper
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? InHeartStep else { return NextFlowItems.none }
        
        switch step {
        case .address:
            return navigateToAddressScreen()
        case .allocateProduct(let deliveryInfo):
            return navigateToAllocateListScreen(deliveryInfo: deliveryInfo)
        case .dismissAddress:
            return NextFlowItems.end(withStepForParentFlow: InHeartStep.dismissAddress)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToAddressScreen() -> NextFlowItems {
        let viewModel = AddressViewModel()
        let viewController = AddressViewController()
        viewController.viewModel = viewModel
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self.addressStepper, action: #selector(AddressStepper.dismiss))
            navigationBarItem.setLeftBarButton(button, animated: true)
        }
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
    private func navigateToAllocateListScreen(deliveryInfo: DeliveryInfo) -> NextFlowItems {
        let viewModel = AllocateViewModel()
        let viewController = AllocateViewController()
        viewController.deliveryInfo = deliveryInfo
        viewController.viewModel = viewModel
        //viewController.title = "Allocate Product"
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewController))
    }
}

class AddressStepper: Stepper, HasDisposeBag {
    init() {
        self.step.accept(InHeartStep.address)
    }
    
    @objc func dismiss() {
        self.step.accept(InHeartStep.dismissAddress)
    }
}
