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
    
    private func paint(initialPanelColor: Color) -> Dictionary<XY, Color> {
        let intcode = Intcode(memory: input().integers)
        
        var panels = Dictionary<XY, Color>()
        var currentHeading = Heading.north
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
                        currentHeading = currentHeading.turnLeft()
                    } else {
                        currentHeading = currentHeading.turnRight()
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
        
        let yRange = panels.keys.map { $0.y }.range
        let xRange = panels.keys.map { $0.x }.range
        
        var painted = ""
        
        for y in yRange {
            for x in xRange {
                let color = panels[XY(x: x, y: y)] ?? .black
                let char = (color == .white) ? "#" : " "
                painted.append(char)
            }
            painted.append("\n")
        }
        
        let recognized = RecognizeLetters(from: painted)
        
        return recognized
    }
    
}
