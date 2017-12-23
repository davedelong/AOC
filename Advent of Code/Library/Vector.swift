//
//  Vector.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

struct Vector: Equatable {
    
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    let x: Int
    let y: Int
    let z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(_ s: String) {
        let num = s.split(separator: ",").map { Int($0)! }
        x = num[0]
        y = num[1]
        z = num[2]
    }
}
