//
//  StringExtension.swift
//  Hangman
//
//  Created by Franck Kindia on 19/07/2024.
//

import UIKit

extension String {
    
    func indicesOf(letter c: Character) -> [String.Index]?{
        var indices = [String.Index]()
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex,
            let range = self.range(of: self, range: startIndex ..< self.endIndex),
              !range.isEmpty
        {
            print(distance(from: self.startIndex, to: range.lowerBound))
            startIndex = range.upperBound
        }
        return indices.count > 0 ? indices : nil
    }
}
