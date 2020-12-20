//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/19/20.
//

import Foundation

public struct Size: Equatable, Hashable {
    
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
}
