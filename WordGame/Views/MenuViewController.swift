//
//  ViewController.swift
//  WordGame
//
//  Created by Сергей Дятлов on 20.09.2024.
//

import UIKit

final class MenuViewController: UIViewController {
    
    var viewModel: GameViewModelProtocol!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForSavedGame()
    }
    
    //MARK: Privet properties
    private let newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle(Keys.Menu.newGame, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.buttonFont)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let continueGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle(Keys.Menu.continueGame, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.buttonFont)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.isHidden = true
        button.addTarget(self, action: #selector(continueGameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = UIConstants.spacing
        return stackView
    }()
    
    //MARK: - Private constants
    private enum UIConstants {
        static let buttonFont: CGFloat = 20
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 10
    }
}

//MARK: Private methods
private extension MenuViewController {
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        buttonStackView.addArrangedSubview(continueGameButton)
        buttonStackView.addArrangedSubview(newGameButton)
        
        setButtonConstraints(button: newGameButton)
        setButtonConstraints(button: continueGameButton)
    }
    
    func setButtonConstraints(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func checkForSavedGame() {
        if viewModel.hasSavedGame() {
            continueGameButton.isHidden = false
        } else {
            continueGameButton.isHidden = true
        }
    }
    
    //MARK: Buttons actions
    @objc func newGameButtonTapped() {
        viewModel.newGame()
    }
    
    @objc func continueGameButtonTapped() {
        viewModel.continueGame()
    }
}
