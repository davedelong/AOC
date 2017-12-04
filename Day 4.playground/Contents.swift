//: Playground - noun: a place where people can play

import Foundation

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!

let raw = try! String(contentsOf: url, encoding: .utf8)
let lines = raw.components(separatedBy: .newlines)

let linesAndWords = lines.map { $0.components(separatedBy: .whitespaces) }.filter { !$0.isEmpty }

func part1(_ input: Array<Array<String>>) -> Int {
    return input.filter { $0.count == Set($0).count }.count
}

let answer1 = part1(linesAndWords)
print(answer1)

func part2(_ input: Array<Array<String>>) -> Int {
    
    func isValid(_ phrase: Array<String>) -> Bool {
        let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
        return countedSets.count == Set(countedSets).count
    }
    
    return input.filter(isValid).count
}

let answer2 = part2(linesAndWords)
