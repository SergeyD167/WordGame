//
//  String + Extension.swift
//  WordGame
//
//  Created by Сергей Дятлов on 25.09.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
