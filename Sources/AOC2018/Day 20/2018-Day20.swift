//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class HeadingNode: GKGraphNode {
    let heading: Heading
    init(heading: Heading) {
        self.heading = heading
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Day20: Day {
    
    struct Node {
        let moves: Array<Heading> // a nil heading would mean "no choice"?
        let next: Array<Node>
    }
    
    func part1() async throws -> String {
        return #function
    }
    
    func part2() async throws -> String {
        return #function
    }
    
}
