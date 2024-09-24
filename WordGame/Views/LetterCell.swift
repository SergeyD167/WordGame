//
//  LetterCell.swift
//  WordGame
//
//  Created by Сергей Дятлов on 23.09.2024.
//

import UIKit

enum CellFont {
    case board
    case keyboard
    case buttons
}

final class LetterCell: UICollectionViewCell {
    
    // MARK: Public
    static let identifier: String = "LetterCell"
    
    let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var letterState: LetterState = .unverified {
        didSet {
            updateAppearance(for: letterState)
        }
    }

    func configure(with letter: Character, font: CellFont, state: LetterState) {
        letterLabel.text = String(letter).uppercased()
        updateFont(for: font)
        letterState = state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = nil
        letterState = .unverified
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private constants
    private enum UIConstants {
        static let cornerRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1
        static let sizeForBoard: CGFloat = 36
        static let sizeForKeyboard: CGFloat = 18
        static let sizeForButton: CGFloat = 28
    }
}

// MARK: Private methods
private extension LetterCell {
    func initialize() {
        layer.cornerRadius = UIConstants.cornerRadius
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = UIConstants.borderWidth
        
        addSubview(letterLabel)
        
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateFont(for font: CellFont) {
        switch font {
        case .board:
            letterLabel.font = .systemFont(ofSize: UIConstants.sizeForBoard, weight: .semibold)
        case .keyboard:
            letterLabel.font = .systemFont(ofSize: UIConstants.sizeForKeyboard, weight: .medium)
        case .buttons:
            letterLabel.font = .systemFont(ofSize: UIConstants.sizeForButton, weight: .medium)
        }
    }
    
    func updateAppearance(for state: LetterState) {
        backgroundColor = state.backgroundColor
        letterLabel.textColor = state.letterColor
    }
}
