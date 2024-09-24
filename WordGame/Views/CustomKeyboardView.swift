//
//  CustomKeyboardView.swift
//  WordGame
//
//  Created by Сергей Дятлов on 23.09.2024.
//

import Foundation
import UIKit

class CustomKeyboardView: UIView {

    var onKeyTap: ((String) -> Void)?
    var onDeleteTap: (() -> Void)?
    var onConfirmTap: (() -> Void)?

    let letters: [[String]] = [
        ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"],
        ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"],
        ["⌫", "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "✓"]
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboard()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupKeyboard()
    }

    private func setupKeyboard() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        // Create rows of buttons
        for i in letters {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 8
            rowStackView.distribution = .fillEqually

            for letter in i {
                let button = createButton(title: letter)
                if letter == "⌫" {
                    button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
                } else if letter == "✓" {
                    button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                }
                rowStackView.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(rowStackView)
        }

        // Layout constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }

    // MARK: - Button Actions
    @objc private func keyTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        onKeyTap?(title)
    }

    @objc private func deleteTapped() {
        onDeleteTap?()
    }

    @objc private func confirmTapped() {
        onConfirmTap?()
    }
}
