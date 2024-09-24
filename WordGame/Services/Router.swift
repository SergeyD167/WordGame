//
//  Router.swift
//  WordGame
//
//  Created by Сергей Дятлов on 20.09.2024.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func navigate(to route: Route)
    func popToRoot()
}
enum Route {
    case menu
    case game(viewModel: GameViewModelProtocol)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        navigate(to: .menu)
    }
    
    func navigate(to route: Route) {
        switch route {
        case .menu:
            if let navigationController = navigationController {
                guard let menuViewController = assemblyBuilder?.createMenu(router: self) else { return }
                navigationController.viewControllers = [menuViewController]
            }
        case .game(let viewModel):
            if let navigationController = navigationController {
                guard let gameViewController = assemblyBuilder?.createGame(viewModel: viewModel) else { return }
                navigationController.pushViewController(gameViewController, animated: true)
            }
        }
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
