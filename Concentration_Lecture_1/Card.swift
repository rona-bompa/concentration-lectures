//
//  Card.swift
//  Concentration_Lecture_1
//
//  Created by Rona Bompa on 18.02.2022.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int

    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
// imbunatatire - Hashable (Lecture 4 - 36:00)
