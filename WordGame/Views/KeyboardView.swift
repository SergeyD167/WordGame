//
//  KeyboardView.swift
//  WordGame
//
//  Created by Сергей Дятлов on 21.09.2024.
//

import Foundation
import UIKit

enum LetterState {
    case unverified      // Прозрачный фон
    case correctPosition // Зеленый фон
    case wrongPosition   // Белый фон
    case notInWord       // Серый фон
    
    var backgroundColor: UIColor {
            switch self {
            case .unverified:
                return .clear
            case .correctPosition:
                return #colorLiteral(red: 0, green: 0.8705882353, blue: 0.0431372549, alpha: 1)
            case .wrongPosition:
                return .white
            case .notInWord:
                return #colorLiteral(red: 0.5843137255, green: 0.5803921569, blue: 0.5803921569, alpha: 1)
            }
        }

        var letterColor: UIColor {
            switch self {
            case .correctPosition, .wrongPosition:
                return .black
            case .notInWord, .unverified:
                return .white
            }
        }
}

protocol KeyboardViewDelegate: AnyObject {
    var isDeleteActive: Bool { get }
    var isSubmitActive: Bool { get }
    func keyboardView(didTapKey letter: Character)
    func keyboardView(stateForKey letter: Character) -> LetterState
}

final class KeyboardView: UIView {
    //MARK: Public
    weak var delegate: KeyboardViewDelegate?
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privet properties
    private let letters = ["йцукенгшщзхъ", "фывапролджэ", "✓ячсмитьбю⌫"]
    private var keys: [[Character]] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.register(LetterCell.self, forCellWithReuseIdentifier: LetterCell.identifier)
        collectionVIew.backgroundColor = .clear
        
        return collectionVIew
    }()
}

//MARK: Private methods
private extension KeyboardView {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        setupConstraints()
        
        keys = letters.map { Array($0) }
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: UICollectionView Data Source & Delegate
extension KeyboardView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.identifier, for: indexPath) as? LetterCell else {
            fatalError("Unable to dequeue LetterCell")
        }

        let letter = keys[indexPath.section][indexPath.row]
        let letterState = delegate?.keyboardView(stateForKey: letter) ?? .unverified
        
        switch letter {
        case "✓":
            guard let isActive = delegate?.isSubmitActive else { break }
            if isActive {
                cell.configure(with: letter, font: .buttons, state: .wrongPosition)
            } else {
                cell.configure(with: letter, font: .buttons, state: .notInWord)
            }
        case "⌫":
            guard let isActive = delegate?.isDeleteActive else { break }
            if isActive {
                cell.configure(with: letter, font: .buttons, state: .wrongPosition)
            } else {
                cell.configure(with: letter, font: .buttons, state: .notInWord)
            }
        default:
            cell.configure(with: letter, font: .keyboard, state: letterState)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width / 14
        let itemHeight = collectionView.frame.height / 5

        if indexPath.section == 2 && (indexPath.item == 0 || indexPath.item == 10) {
            return CGSize(width: itemWidth * 1.75, height: itemHeight)
        }
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth = collectionView.frame.width / 14

        if section == 1 {
            return UIEdgeInsets(top: 5, left: itemWidth, bottom: 5, right: itemWidth)
        }
        
        return UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.keyboardView(didTapKey: letter)
    }
}
