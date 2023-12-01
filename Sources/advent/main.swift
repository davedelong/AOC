//
//  File.swift
//  
//
//  Created by Dave DeLong on 9/24/19.
//

import AOC

AOCCore.authenticationToken = "53616c7465645f5f0e0e98726b27674cce71e2414d62c5cc7020fcdc2f136106c0bcb4683f5a304e33041aaae7c767886036ceb374d9d02c2979c9657149adcc"
let d = AOC2023.today()

let d1 = Date()
let (p1, p2) = try await d.run()
let d2 = Date()
print("Executing \(type(of: d))")
print("Part 1: \(p1)")
print("Part 2: \(p2)")
print("Time: \(d2.timeIntervalSince(d1))")
