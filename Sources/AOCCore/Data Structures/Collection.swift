//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/30/23.
//

import Foundation

public extension Collection where Element: Collection {
    
    var flattened: Array<Element.Element> {
        flatMap { $0 }
    }
    
    func recognizeLetters(isLetterCharacter: (Element.Element) -> Bool) -> String {
        return RecognizeLetters(in: self, isLetterCharacter: isLetterCharacter)
    }
    
}

public extension Collection where Element: Collection, Element.Element == Bool {
    
    func recognizeLetters() -> String {
        return RecognizeLetters(in: self)
    }
    
}

public extension Collection where Element: Collection, Element.Element: Hashable {
    
    var commonElements: Set<Element.Element> {
        if self.isEmpty { return [] }
        
        var set = Set(self.first!)
        for remaining in self.dropFirst() {
            // this extra Set() call here is necessary because of this:
            // https://github.com/apple/swift/pull/59422
            //
            // This was discovered in Swift 5.7
            set.formIntersection(Set(remaining))
            
            if set.isEmpty { break }
        }
        return set
    }
    
}

public extension Collection where Element: RandomAccessCollection {
    
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    var transposed: Array<[Element.Element]> {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map { $0[index] }
        }
    }
    
}

public extension RandomAccessCollection where Element: RandomAccessCollection {
    
    subscript(vertical index: Element.Index) -> LazyMapCollection<Self, Element.Element> {
        return lazy.map { $0[index] }
    }
}

extension Array {
    
    public func shift(_ amount: Int) -> Array<Element> {
        let shiftRight = (amount >= 0)
        let shiftAmount = Int(amount.magnitude).quotientAndRemainder(dividingBy: self.count).remainder
        
        if shiftAmount == 0 { return self }
        
        if shiftRight {
            return Array(self.last(shiftAmount)) + Array(self.dropLast(shiftAmount))
        } else {
            return Array(self.dropFirst(shiftAmount)) + Array(self.prefix(shiftAmount))
        }
        
    }
}
