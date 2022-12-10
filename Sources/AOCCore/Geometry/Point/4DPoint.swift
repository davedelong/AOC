//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import Foundation

public struct Point4: PointProtocol {
    public typealias Vector = Vector4
    public typealias Span = PointSpan4
    public static let numberOfComponents = 4
    
    public var components: Array<Int> {
        get { [x, y, z, t] }
        set {
            Self.assertComponents(newValue)
            x = newValue[0]
            y = newValue[1]
            z = newValue[2]
            t = newValue[3]
        }
    }
    
    public var x: Int
    public var y: Int
    public var z: Int
    public var t: Int
    
    public init(_ components: Array<Int>) {
        Self.assertComponents(components)
        self.x = components[0]
        self.y = components[1]
        self.z = components[2]
        self.t = components[3]
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.t = t
    }
}
