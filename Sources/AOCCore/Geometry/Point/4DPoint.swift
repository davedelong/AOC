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
    
    public var components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var z: Int { return components[2] }
    public var t: Int { return components[3] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Point4.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point4.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) { self.init([x, y, z, t]) }
}
