//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/30/23.
//

import Foundation

extension Regex where Output == (Substring, Substring) {
    
    public static var integers: Self { /(-?\d+)/ } 
    
}
