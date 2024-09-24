//
//  AssemblyBuilder.swift
//  WordGame
//
//  Created by Сергей Дятлов on 24.09.2024.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMenu(router: RouterProtocol) -> UIViewController
    func createGame(viewModel: GameViewModelProtocol) -> UIViewController
}

class AssemblyModulBuilder: AssemblyBuilderProtocol {
    func createMenu(router: RouterProtocol) -> UIViewController {
        let storage = StorageManager()
        let gameStorage = GameStorageManager(storageManager: storage)
        let view = MenuViewController()
        let viewModel = GameViewModel(storageManager: gameStorage, router: router)
        view.viewModel = viewModel
        return view
    }
    
    func createGame(viewModel: GameViewModelProtocol) -> UIViewController {
        let view = GameViewController()
        view.viewModel = viewModel
        return view
    }
}
