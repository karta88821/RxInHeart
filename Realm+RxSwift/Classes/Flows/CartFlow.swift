//
//  CartFlow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/11.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxFlow

class CartFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let cartStepper: CartStepper

    init(with stepper: CartStepper) {
        self.cartStepper = stepper
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? InHeartStep else { return NextFlowItems.none }

        switch step {
        case .cart:
            return navigateToCartScreen()
        case .productList:
            return navigateToProductListScreen()
        case .form:
            return navigateToFormScreen()
        case .address:
            return navigateToAddressScreen()
        case .infoDetail:
            return navigateToInfoDetailScreen()
        case .dismissInfo:
            self.rootViewController.presentedViewController?.dismiss(animated: true)
            return NextFlowItems.none
        case .sendOrder(let sendModel):
            return navigateToSendOrderScreen(with: sendModel)
        case .orderDetail(let sendModel):
            return navigateToOrderInfoScreen(with: sendModel)
        case .dismissAddress:
            self.rootViewController.presentedViewController?.dismiss(animated: true)
            return NextFlowItems.none
        case .dismissCart:
            return NextFlowItems.end(withStepForParentFlow: InHeartStep.dismissCart)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToCartScreen() -> NextFlowItems {
        let viewModel = CartViewModel()
        let viewController = CartViewController()
        viewController.title = "購物車"
        viewController.viewModel = viewModel
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self.cartStepper, action: #selector(CartStepper.dismiss))
            navigationBarItem.setLeftBarButton(button, animated: true)
        }
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
    private func navigateToProductListScreen() -> NextFlowItems {
        let viewModel = ProductListViewModel()
        let viewController = ProductListController()
        viewController.viewModel = viewModel
        viewController.title = "ProductList"
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
    private func navigateToFormScreen() -> NextFlowItems {
        let viewController = FormViewController()
        let viewModel = FormViewModel()
        viewController.viewModel = viewModel
        viewController.title = "Form"
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
    private func navigateToAddressScreen() -> NextFlowItems {
        let addressStepper = AddressStepper()
        let addressFlow = AddressFlow(with: addressStepper)
        Flows.whenReady(flow1: addressFlow, block: { [unowned self] (root: UINavigationController) in
            root.navigationBar.isTranslucent = false
            root.navigationBar.makeShadow()
            self.rootViewController.present(root, animated: true)
        })
        
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: addressFlow, nextStepper: addressStepper))
    }
    
    private func navigateToInfoDetailScreen() -> NextFlowItems {
        let infoDetailStepper = InfoDetailStepper()
        let infoDetailFlow = InfoDetailFlow(with: infoDetailStepper)
        Flows.whenReady(flow1: infoDetailFlow, block: { [unowned self] (root: UINavigationController) in
            root.navigationBar.isTranslucent = false
            root.navigationBar.makeShadow()
            self.rootViewController.present(root, animated: true)
        })
        
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: infoDetailFlow, nextStepper: infoDetailStepper))
    }
    
    private func navigateToSendOrderScreen(with sendModel: SendOrderModel) -> NextFlowItems {
        let viewModel = SendOrderViewModel()
        let viewController = SendOrderViewController()
        viewController.viewModel = viewModel
        viewController.sendModel = sendModel
        viewController.title = "SendOrder"
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
    }
    
    private func navigateToOrderInfoScreen(with sendModel: SendOrderModel) -> NextFlowItems {
        let viewModel = OrderInfoViewModel()
        let viewController = OrderInfoViewController()
        viewController.viewModel = viewModel
        viewController.sendModel = sendModel
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.none
    }
}

class CartStepper: Stepper, HasDisposeBag {
    init() {
        self.step.accept(InHeartStep.cart)
    }
    @objc func dismiss() {
        self.step.accept(InHeartStep.dismissCart)
    }
}

