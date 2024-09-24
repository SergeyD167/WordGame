//
//  WordCell.swift
//  WordGame
//
//  Created by Сергей Дятлов on 20.09.2024.
//

import UIKit

class WordCell: UICollectionViewCell {
    
    //MARK: - Public
    static let identifier: String = "WordCell"
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private methods
private extension WordCell {
    func initialize() {
        layer.cornerRadius = 4
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}
