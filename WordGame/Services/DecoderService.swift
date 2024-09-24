//
//  DecoderService.swift
//  WordGame
//
//  Created by Сергей Дятлов on 23.09.2024.
//

import Foundation

protocol DecoderServiceProtocol {
    func loadWordsStringsFromFile() async throws -> [String]
}

final class DecoderService: DecoderServiceProtocol {
    
    static let shared = DecoderService()
    
    private init() {}
    
    func loadWordsStringsFromFile() async throws -> [String] {
        guard let fileURL = Bundle.main.url(forResource: "words", withExtension: "json") else {
            throw NSError(domain: "DecoderService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Couldn't find file"])
        }

        return try await decodeWords(from: fileURL)
    }
    
    //MARK: Private Methods
    private func decodeWords(from fileURL: URL) async throws -> [String] {
        let data = try Data(contentsOf: fileURL)
        let wordsData = try JSONDecoder().decode(WordsData.self, from: data)
        return wordsData.words
    }
}
