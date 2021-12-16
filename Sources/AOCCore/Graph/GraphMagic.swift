//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/15/21.
//

import Foundation

/*
 This is needed because the Graph and GridGraph types are backed by an NSObject
 and `isKnownUniquelyReferenced` "doesn't like" NSObjects.
 
 So, we have to wrap the NSObject in a Swift object, just so we can use
 `isKnownUniquelyReferenced`.
 
 I am shooketh.
 */

class RefBox<O: NSObject> {
    var object: O
    init(_ object: O) {
        self.object = object
    }
}
