//
//  GameManager.swift
//  WordGame
//
//  Created by Сергей Дятлов on 24.09.2024.
//

import Foundation

protocol GameStorageManagerProtocol {
    func saveGameState(guesses: [[Character?]], answer: String, checkedRows: Set<Int>)
    func updateGuesses(_ guesses: [[Character?]])
    func updateAnswer(_ answer: String)
    func updateCheckedRows(_ checkedRows: Set<Int>)
    func loadGameState() -> (guesses: [[Character?]], answer: String, checkedRows: Set<Int>)?
    func deleteGameState()
}

final class GameStorageManager: GameStorageManagerProtocol {
    private let storageManager: StorageManagerProtocol
    private let guessesKey = "savedGuesses"
    private let answerKey = "savedAnswer"
    private let checkedRowsKey = "savedCheckedRows"
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }

    func saveGameState(guesses: [[Character?]], answer: String, checkedRows: Set<Int>) {
        let guessesData = guesses.map { $0.map { $0.map { String($0) } ?? "" } }
        storageManager.save(guessesData, forKey: guessesKey)
        storageManager.save(answer, forKey: answerKey)
        storageManager.save(Array(checkedRows), forKey: checkedRowsKey)
    }
    
    func updateGuesses(_ guesses: [[Character?]]) {
        let guessesData = guesses.map { $0.map { $0.map { String($0) } ?? "" } }
        storageManager.save(guessesData, forKey: guessesKey)
    }
    
    func updateAnswer(_ answer: String) {
        storageManager.save(answer, forKey: answerKey)
    }
    
    func updateCheckedRows(_ checkedRows: Set<Int>) {
        storageManager.save(Array(checkedRows), forKey: checkedRowsKey)
    }

    func loadGameState() -> (guesses: [[Character?]], answer: String, checkedRows: Set<Int>)? {
        guard let guessesData = storageManager.load(forKey: guessesKey) as [[String]]?,
              let answer = storageManager.load(forKey: answerKey) as String?,
              let checkedRowsData = storageManager.load(forKey: checkedRowsKey) as [Int]? else {
            return nil
        }

        let guesses = guessesData.map { $0.map { $0.isEmpty ? nil : Character($0) } }
        let checkedRows = Set(checkedRowsData)
        
        return (guesses, answer, checkedRows)
    }
    
    func deleteGameState() {
        storageManager.delete(forKey: guessesKey)
        storageManager.delete(forKey: answerKey)
        storageManager.delete(forKey: checkedRowsKey)
    }
}
