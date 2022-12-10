//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day11: Day {
    
    enum Color: Int {
        case black = 0
        case white = 1
    }
    
    private func paint(initialPanelColor: Color) -> Space<Point2, Color> {
        let intcode = Intcode(memory: input().integers)
        
//        var panels = Dictionary<XY, Color>()
        var panels = Space<Point2, Color>()
        var currentHeading = Heading.south
        var currentPosition = XY.zero
        panels[currentPosition] = initialPanelColor
        
        var wantsColor = true
        
        while intcode.isHalted == false {
            intcode.runUntilBeforeNextIO()
            if intcode.isHalted { break }
            if intcode.needsIO() {
                intcode.io = (panels[currentPosition] ?? .black).rawValue
                intcode.step()
            } else {
                intcode.step()
                if wantsColor == true {
                    panels[currentPosition] = Color(rawValue: intcode.io!)!
                } else {
                    if intcode.io! == 0 {
                        currentHeading = currentHeading.turnRight()
                    } else {
                        currentHeading = currentHeading.turnLeft()
                    }
                    currentPosition = currentPosition.move(currentHeading)
                }
                wantsColor.toggle()
            }
        }
        return panels
    }
    
    func part1() async throws -> String {
        let panels = paint(initialPanelColor: .black)
        let count = panels.count
        return "\(count)"
    }
    
    func part2() async throws -> String {
        let panels = paint(initialPanelColor: .white)
        panels.draw(using: {
            $0 == .white ? "#" : "."
        })
        return panels.recognizeLetters(isLetterCharacter: { $0 == .white })
    }
    
}
