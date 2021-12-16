//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/15/21.
//

import Foundation

extension Graph {
    
    public init<C: Collection>(_ items: C) where C.Element: Identifiable, ID == C.Element.ID, Value == C.Element {
        self.init()
        for item in items {
            self[item.id] = item
        }
    }
    
}
