//
//  String.swift
//  AOC
//
//  Created by Dave DeLong on 12/9/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension String {
    
    func locate(_ substring: String) -> Array<Range<String.Index>> {
        
        var indices = Array<Range<String.Index>>()
        
        var r = startIndex ..< endIndex
        while let i = range(of: substring, options: [], range: r, locale: nil) {
            indices.append(i)
            r = i.upperBound ..< endIndex
        }
        return indices
    }
    
}
