//: Playground - noun: a place where people can play

import Foundation

let input = 277678

func part1(_ input: Int) -> Int {
    let squareRootOfInput = sqrt(Double(input))
    let roundedUp = Int(ceil(squareRootOfInput))
    let root = (roundedUp % 2 == 0) ? roundedUp + 1 : roundedUp
    let layer = (root - 1) / 2
    let lengthOfSide = root

    let cornerValue = root * root
    let sideOfSquare = (cornerValue - input) / lengthOfSide
    let targetCorner = cornerValue - (sideOfSquare * lengthOfSide)
    let middleOfSide = targetCorner - (lengthOfSide / 2)

    let distanceToMiddle = abs(input - middleOfSide)
    let distanceFromMiddleToCenter = layer

    let totalDistance = distanceToMiddle + distanceFromMiddleToCenter
    return totalDistance
}

/*
func part2(_ input: Int) -> Int {
    
    func layerOffset2Index(_ layer: Int, offset: Int) -> Int { return 0 }
    func index2LayerOffset(_ index: Int) -> (Int, Int) { return (0, 0) }
    
    let upperBound = Int(ceil(sqrt(Double(input)))) + 1
    var values = Array<Int?>(repeating: nil, count: upperBound)
    values[1] = 1
    for i in 2 ..< upperBound {
        let (layer, offset) = index2LayerOffset(i)
    }
    
    // i couldn't come up with a way to reliably solve this
    // so i did it in Numbers.app 🤷‍♂️
}
 let answer2 = part2(input)
 */

let answer1 = part1(input)
