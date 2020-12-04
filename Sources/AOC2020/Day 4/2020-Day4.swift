//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day4: Day {
    typealias Passport = [String: String]
    
    let fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    let colors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    
    override func run() -> (String, String) {
        let r: Regex = #"^(.+):(.+)$"#
        let passportChunks = input.raw.components(separatedBy: "\n\n")
        let passports = passportChunks.map { chunk -> Passport in
            let pairs = chunk
                .components(separatedBy: .whitespacesAndNewlines)
                .compactMap { r.match($0) }
                .map { ($0[1]!, $0[2]!) }
            return Dictionary(uniqueKeysWithValues: pairs)
        }
        
        let p1 = passports.filter(p1_isValid(_:))
        let p2 = p1.filter(p2_isValid(_:))
        
        return ("\(p1.count)", "\(p2.count)")
    }
    
    private func p1_isValid(_ ps: Passport) -> Bool {
        return fields.allSatisfy(ps.keys.contains)
    }
    
    private func p2_isValid(_ ps: Passport) -> Bool {
        guard let byr = ps["byr"].flatMap(Int.init) else { return false }
        guard (1920...2002).contains(byr) else { return false }
        
        guard let iyr = ps["iyr"].flatMap(Int.init) else { return false }
        guard (2010...2020).contains(iyr) else { return false }
        
        guard let eyr = ps["eyr"].flatMap(Int.init) else { return false }
        guard (2020...2030).contains(eyr) else { return false }
        
        guard let hgt = ps["hgt"] else { return false }
        guard hgt.hasSuffix("cm") || hgt.hasSuffix("in") else { return false }
        guard let h = Int(hgt.dropLast(2)) else { return false }
        if hgt.hasSuffix("cm") {
            guard (150...193).contains(h) else { return false }
        } else {
            guard (59...76).contains(h) else { return false }
        }
        
        guard let hcl = ps["hcl"] else { return false }
        guard hcl.count == 7 else { return false }
        guard hcl.first == "#" else { return false }
        guard hcl.dropFirst().allSatisfy(\.isHexDigit) else { return false }
        
        guard let ecl = ps["ecl"] else { return false }
        guard colors.contains(ecl) else { return false }
        
        guard let pid = ps["pid"] else { return false }
        guard pid.count == 9 else { return false }
        
        return true
    }

}
