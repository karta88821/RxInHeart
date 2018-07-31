//
//  SelectedFlow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxFlow

class SelectedFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let selectedStepper: SelectedStepper

    init(with stepper: SelectedStepper) {
        self.selectedStepper = stepper
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? InHeartStep else { return NextFlowItems.none }
        
        switch step {
        case .mainSelected:
            return navigateToMainScreen()
        case .selected(let compositionId):
            return navigateToSelectedScreen(with: compositionId)
        case .selectedDone:
            return NextFlowItems.none
        case .cart:
            return navigateToCartScreen()
        case .dismissCart:
            self.rootViewController.presentedViewController?.dismiss(animated: true)
            return NextFlowItems.none
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToMainScreen () -> NextFlowItems {
        let viewController = MainViewController()
        viewController.viewModel = MainViewModel()
        
        self.rootViewController.pushViewController(viewController, animated: true)
        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
            
            let icon = UIImage(named: "cart")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
            let iconButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            iconButton.setImage(icon, for: .normal)
            iconButton.imageView?.contentMode = .scaleAspectFill

            let barButton = UIBarButtonItem(customView: iconButton)
            iconButton.addTarget(self.selectedStepper, action: #selector(SelectedStepper.goCart), for: .touchUpInside)

            let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0))
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height: 44.0))

            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
            titleLabel.textColor = .black
            titleLabel.text = "IN HEART"
            customView.addSubview(titleLabel)

            let leftView = UIBarButtonItem(customView: customView)
            
            navigationBarItem.leftBarButtonItem = leftView
            navigationBarItem.rightBarButtonItem = barButton

        }
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewController.viewModel))
    }
    
    private func navigateToSelectedScreen(with id: Int) -> NextFlowItems {
        let viewModel = SelectedViewModel(id: id)
        let viewController = SelectedViewController()
        viewController.viewModel = viewModel
        viewController.title = "選擇品項" 
        self.rootViewController.pushViewController(viewController, animated: true)
        return NextFlowItems.none
    }
    
    private func navigateToCartScreen() -> NextFlowItems {
        let cartStepper = CartStepper()
        let cartFlow = CartFlow(with: cartStepper)
        Flows.whenReady(flow1: cartFlow, block: { [unowned self] (root: UINavigationController) in
            root.navigationBar.isTranslucent = false
            root.navigationBar.makeShadow()
            self.rootViewController.present(root, animated: true)
        })
    
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: cartFlow, nextStepper: cartStepper))
    }
    
}

class SelectedStepper: Stepper, HasDisposeBag {
    init() {
        self.step.accept(InHeartStep.mainSelected)
    }
    @objc func goCart() {
        self.step.accept(InHeartStep.cart)
    }
}
