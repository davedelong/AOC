//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import Foundation

public struct Point3: PointProtocol {
    public typealias Vector = Vector3
    public typealias Span = PointSpan3
    public static let numberOfComponents = 3
    
    public var components: Array<Int> {
        get { [x, y, z] }
        set {
            Self.assertComponents(newValue)
            x = newValue[0]
            y = newValue[1]
            z = newValue[2]
        }
    }
    
    public var x: Int
    public var y: Int
    public var z: Int
    
    public init(_ components: Array<Int>) {
        Self.assertComponents(components)
        self.init(x: components[0], y: components[1], z: components[2])
    }
    
    public init(x: Int, y: Int, z: Int) { self.x = x; self.y = y; self.z = z }
}
