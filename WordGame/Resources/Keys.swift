//
//  Keys.swift
//  WordGame
//
//  Created by Сергей Дятлов on 25.09.2024.
//

import UIKit

enum Keys {
    
    enum Colors {
        static let green = UIColor(red: 0, green: 0.8705882353, blue: 0.0431372549, alpha: 1)
        static let gray = UIColor(red: 0.5843137255, green: 0.5803921569, blue: 0.5803921569, alpha: 1)
    }
    
    enum Images {
        static let backButton = "chevron.left"
    }
    
    enum Menu {
        static let newGame = "new_game".localized
        static let continueGame = "continue_game".localized
    }
    
    enum Game {
        static let congratulations = "congratulations".localized
        static let win = "win".localized
        static let gameOver = "game_over".localized
        static let lose = "lose".localized
        static let restart = "restart".localized
        static let again = "again".localized
        static let exit = "exit".localized
        
        static let words = "words".localized
    }
    
    enum Keyboard {
        static let submit: Character = "✓"
        static let delete: Character = "⌫"
    }
}
