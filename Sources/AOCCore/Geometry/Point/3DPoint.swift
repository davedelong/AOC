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
    
    public var components: Array<Int> { [x, y, z] }
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    public init(_ components: Array<Int>) {
        guard components.count == Point3.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point3.numberOfComponents), but got \(components.count)")
        }
        self.init(x: components[0], y: components[1], z: components[2])
    }
    
    public init(x: Int, y: Int, z: Int) { self.x = x; self.y = y; self.z = z }
}
