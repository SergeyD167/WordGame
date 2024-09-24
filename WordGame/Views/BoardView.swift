//
//  BoardViewController.swift
//  WordGame
//
//  Created by Сергей Дятлов on 20.09.2024.
//

import UIKit

protocol BoardViewDatasource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> LetterState
}

final class BoardView: UIView {
    
    //MARK: Public
    weak var dataSource: BoardViewDatasource?
    
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
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = UIConstants.minimumSpacing
        layout.minimumLineSpacing = UIConstants.minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: UIConstants.sectionInset, left: 0, bottom: UIConstants.sectionInset, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: LetterCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: Private constants
    private enum UIConstants {
        static let minimumSpacing: CGFloat = 10
        static let sectionInset: CGFloat = 5
        static let numberOfItems: CGFloat = 5
    }
}

//MARK: Private methods
private extension BoardView {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        setupConstraints()
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension BoardView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.currentGuesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.currentGuesses[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.identifier, for: indexPath) as? LetterCell else {
            fatalError("Unable to dequeue LetterCell")
        }

        if let letter = dataSource?.currentGuesses[indexPath.section][indexPath.row],
           let letterState = dataSource?.boxColor(at: indexPath) {
            cell.configure(with: letter, font: .board, state: letterState)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 40) / UIConstants.numberOfItems
        return CGSize(width: side, height: side)
    }
}
