//
//  KeyboardViewController.swift
//  WordGame
//
//  Created by Сергей Дятлов on 23.09.2024.
//

import Foundation
import UIKit

class KeyboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var onKeyTap: ((String) -> Void)?
    var onDeleteTap: (() -> Void)?
    var onConfirmTap: (() -> Void)?
    
    let letters: [[String]] = [
        ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"],
        ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"],
        ["⌫", "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "✓"]
    ]
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KeyboardCell.self, forCellWithReuseIdentifier: "KeyboardCell")
        collectionView.backgroundColor = .black

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return letters.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardCell", for: indexPath) as! KeyboardCell
        let letter = letters[indexPath.section][indexPath.item]
        cell.configure(with: letter)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 8 * 12 // 8 spacing * (12 columns - 1)
        let itemWidth = (collectionView.frame.width - totalSpacing) / 12
        return CGSize(width: itemWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let letter = letters[indexPath.section][indexPath.item]
        if letter == "⌫" {
            onDeleteTap?()
        } else if letter == "✓" {
            onConfirmTap?()
        } else {
            onKeyTap?(letter)
        }
    }
}

// MARK: - Класс ячейки
class KeyboardCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        contentView.addSubview(label)
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with letter: String) {
        label.text = letter
    }
}
