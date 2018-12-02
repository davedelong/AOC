//
//  Collection.swift
//  AOC
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension Collection where Element: Numeric {
    
    public func sum() -> Element {
        var s = Element.init(exactly: 0)!
        for item in self {
            s += item
        }
        return s
    }
    
}
