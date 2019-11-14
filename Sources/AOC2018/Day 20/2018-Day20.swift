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

extension Year2018 {

    public class Day20: Day {
        
        struct Node {
            let moves: Array<Heading> // a nil heading would mean "no choice"?
            let next: Array<Node>
        }
        
        public init() { super.init(inputFile: #file) }
        
        override public func part1() -> String {
            return #function
        }
        
        override public func part2() -> String {
            return #function
        }
        
    }

}
