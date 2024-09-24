//
//  KeyboardCell.swift
//  WordGame
//
//  Created by Сергей Дятлов on 23.09.2024.
//

import UIKit

final class KeyboardCell: UICollectionViewCell {
    
    //MARK: - Public
    static let identifier: String = "KeyboardCell"
    
    func configure(with letter: Character) {
        letterLabel.text = String(letter).uppercased()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        letterLabel.text = nil
//    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privet properties
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
}

//MARK: - Private methods
private extension KeyboardCell {
    func initialize() {
        
        addSubview(letterLabel)
        
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
