//
//  GameVIewModel.swift
//  WordGame
//
//  Created by Сергей Дятлов on 24.09.2024.
//

import Foundation

protocol GameViewModelProtocol {
    var answer: String { get }
    var guesses: [[Character?]] { get }
    var checkedRows: Set<Int> { get }
    var answers: [String] { get }
    var currentRowForInput: Int { get }
    
    var isDeleteActive: Bool { get }
    var isSubmitActive: Bool { get }
    
    var isWordGuessed: Bool { get }
    var isGameOver: Bool { get }
    
    func letterState(at indexPath: IndexPath) -> LetterState
    func letterState(for letter: Character) -> LetterState
    func addLetter(letter: Character)
    func removeLastCharacter()
    func submitInput(forRow row: Int)
    
    func hasSavedGame() -> Bool
    func resetGameState()
    
    func newGame()
    func continueGame()
    func popToRoot()
}

final class GameViewModel: GameViewModelProtocol {
    var answer: String = ""
    var guesses: [[Character?]]
    var checkedRows: Set<Int> = []
    var answers: [String] = []
    var currentRowForInput: Int = 0
    
    var isDeleteActive = false
    var isSubmitActive = false
    
    var isGameOver = false
    var isWordGuessed: Bool {
        return guesses.contains { $0.compactMap { String($0 ?? ".") }.joined() == answer }
    }
    
    private let storageManager: GameStorageManagerProtocol
    private let router: RouterProtocol
    
    init(storageManager: GameStorageManagerProtocol, router: RouterProtocol) {
        self.storageManager = storageManager
        self.router = router
        self.guesses = Array(repeating: Array(repeating: nil, count: 5), count: 6)
        
        if let savedState = storageManager.loadGameState() {
            self.guesses = savedState.guesses
            self.answer = savedState.answer
            self.checkedRows = savedState.checkedRows
            self.currentRowForInput = findNextRowForInput()
        }
    }
    
    //MARK: Storage
    func hasSavedGame() -> Bool {
        return loadGameState() != nil
    }
    
    func resetGameState() {
        storageManager.deleteGameState()
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 6)
        checkedRows.removeAll()
        answer = answers.randomElement() ?? "слово"
        currentRowForInput = 0
        isGameOver = false
    }
    
    //MARK: Route
    func newGame() {
        resetGameState()
        
        Task {
            do {
                try await loadWords()
            } catch {
                print("Failed to load words: \(error.localizedDescription)")
            }
        }
        router.navigate(to: .game(viewModel: self))
    }
    
    func continueGame() {
        router.navigate(to: .game(viewModel: self))
    }
    
    func popToRoot() {
        guesses[currentRowForInput] = Array(repeating: nil, count: 5)
        router.popToRoot()
    }
    
    //MARK: Update UI
    func letterState(at indexPath: IndexPath) -> LetterState {
        let rowIndex = indexPath.section
        
        guard checkedRows.contains(rowIndex) else {
            return .unverified
        }

        guard let letter = guesses[rowIndex][indexPath.row] else {
            return .notInWord
        }

        let indexedAnswer = Array(answer)

        if indexedAnswer[indexPath.row] == letter {
            return .correctPosition
        } else if indexedAnswer.contains(letter) {
            return .wrongPosition
        }

        return .notInWord
    }
    
    func letterState(for letter: Character) -> LetterState {
        for rowIndex in 0..<guesses.count {
            if checkedRows.contains(rowIndex) {
                let guess = guesses[rowIndex]
                
                if let index = guess.firstIndex(of: letter) {
                    let indexPath = IndexPath(row: index, section: rowIndex)
                    return letterState(at: indexPath)
                }
            }
        }
        return .unverified
    }
    
    //MARK: Keyboard metods
    func addLetter(letter: Character) {
        if let index = guesses[currentRowForInput].firstIndex(where: { $0 == nil }) {
            guesses[currentRowForInput][index] = letter
        }
        
        updateButtonState()
    }
    
    func removeLastCharacter() {
        guard isDeleteActive else { return }
        if let index = guesses[currentRowForInput].lastIndex(where: { $0 != nil }) {
            guesses[currentRowForInput][index] = nil
        }
        updateButtonState()
    }
    
    func submitInput(forRow row: Int) {
        guard isSubmitActive else { return }
        
        checkedRows.insert(row)
        saveGameState()
        
        currentRowForInput = findNextRowForInput()
        
        updateButtonState()
        
        checkWin()        
    }
    
    //MARK: Private methods
    private func loadWords() async throws {
        let loadedWords = try await DecoderService.shared.loadWordsStringsFromFile()
        self.answers = loadedWords
        self.answer = loadedWords.randomElement() ?? "слово"
        print(answer)
    }
    
    private func loadGameState() -> (guesses: [[Character?]], answer: String, checkedRows: Set<Int>)? {
        return storageManager.loadGameState()
    }
    
    private func saveGameState() {
        storageManager.saveGameState(guesses: guesses, answer: answer, checkedRows: checkedRows)
    }
    
    private func findNextRowForInput() -> Int {
        for rowIndex in 0..<guesses.count {
            if !checkedRows.contains(rowIndex) {
                return rowIndex
            }
        }
        return guesses.count - 1
    }
    
    private func updateButtonState() {
        let filledLettersCount = guesses[currentRowForInput].compactMap { $0 }.count
        if filledLettersCount > 0 {
            isDeleteActive = true
        } else {
            isDeleteActive = false
        }
        
        if filledLettersCount == 5 {
            isSubmitActive = true
        } else {
            isSubmitActive = false
        }
    }
    
    private func checkWin() {
        let currentGuess = guesses[currentRowForInput].compactMap { $0 }
        if currentGuess.count == 5 {
            let guessedWord = String(currentGuess)
            if guessedWord == answer {
                return
            } else {
                currentRowForInput += 1

                if currentRowForInput >= 6 {
                    isGameOver = true
                }
            }
        }
    }
}


