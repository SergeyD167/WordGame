//
//  GameViewController.swift
//  WordGame
//
//  Created by Сергей Дятлов on 20.09.2024.
//

import UIKit

final class GameViewController: UIViewController {
    var viewModel: GameViewModelProtocol!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Private properties
    private let keyboardView = KeyboardView()
    private let boardView = BoardView()
}

// MARK: Private methods
private extension GameViewController {
    
    func setupUI() {
        view.backgroundColor = .black
        keyboardView.delegate = self
        boardView.dataSource = self
        
        view.addSubview(boardView)
        view.addSubview(keyboardView)
        
        setupConstraints()
        setupNavigationBar()
    }
    
    func setupConstraints() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            keyboardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы угадали слово! Начинается новый раунд.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.viewModel.resetGameState()
            self.boardView.reloadData()
            self.keyboardView.reloadData()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Игра окончена", message: "К сожалению, попытки закончились. Загаданное слово было \(viewModel.answer). Вы можете сыграть еще раз.", preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: "Играть еще раз", style: .default) { _ in
            self.viewModel.resetGameState()
            self.boardView.reloadData()
            self.keyboardView.reloadData()
        }
        
        let exitAction = UIAlertAction(title: "Выйти из игры", style: .destructive) { _ in
            self.viewModel.resetGameState()
            self.viewModel.popToRoot()
        }
        
        alert.addAction(playAgainAction)
        alert.addAction(exitAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "5 букв"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        navigationItem.titleView = titleLabel
        
        let boldChevron = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let backButton = UIBarButtonItem(image: boldChevron, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    func appendToTextField(letter: Character) {
        viewModel.addLetter(letter: letter)
    }
    
    func deleteLastCharacter() {
        viewModel.removeLastCharacter()
    }
    
    func submitInput() {
        viewModel.submitInput(forRow: viewModel.currentRowForInput)
        checkGameStatus()
    }
    
    func checkGameStatus() {
        if viewModel.isWordGuessed {
            showAlert()
        } else if viewModel.isGameOver {
                self.showGameOverAlert()
        }
    }
    
    @objc private func backButtonTapped() {
        viewModel.popToRoot()
    }
}

// MARK: KeyboardViewDelegate
extension GameViewController: KeyboardViewDelegate {
    var isDeleteActive: Bool {
        viewModel.isDeleteActive
    }
    
    var isSubmitActive: Bool {
        viewModel.isSubmitActive
    }
    
    func keyboardView(stateForKey letter: Character) -> LetterState {
        return viewModel.letterState(for: letter)
    }
    
    func keyboardView(didTapKey letter: Character) {
        switch letter {
        case "✓":
            submitInput()
        case "⌫":
            deleteLastCharacter()
        default:
            appendToTextField(letter: letter)
        }
        
        boardView.reloadData()
        keyboardView.reloadData()
    }
}

// MARK: BoardViewDatasource
extension GameViewController: BoardViewDatasource {
    var currentGuesses: [[Character?]] {
        return viewModel.guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> LetterState {
        viewModel.letterState(at: indexPath)
    }
}
