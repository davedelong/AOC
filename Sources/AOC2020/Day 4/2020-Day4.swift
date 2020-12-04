//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day4: Day {

    override func run() -> (String, String) {
        let passportChunks = input.raw.components(separatedBy: "\n\n")
        
        let r: Regex = #"\s*(.+?):([^\s]+)"#
        
        let passports = passportChunks.compactMap { chunk -> Dictionary<String, String>? in
            var fields = Dictionary<String, String>()
            for match in r.matches(in: chunk) {
                fields[match[1]!] = match[2]!
            }
            guard fields.isNotEmpty else { return nil }
            return fields
        }
        
        let fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let p1 = passports.filter { ps in
            for f in fields {
                if ps[f] == nil { return false }
            }
            return true
        }
        
        let colors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
        let p2 = passports.filter { ps in
            guard let byr = ps["byr"].flatMap(Int.init) else { return false }
            guard byr >= 1920 && byr <= 2002 else { return false }
            
            guard let iyr = ps["iyr"].flatMap(Int.init) else { return false }
            guard iyr >= 2010 && iyr <= 2020 else { return false }
            
            guard let eyr = ps["eyr"].flatMap(Int.init) else { return false }
            guard eyr >= 2020 && eyr <= 2030 else { return false }
            
            guard let hgt = ps["hgt"] else { return false }
            guard hgt.hasSuffix("cm") || hgt.hasSuffix("in") else { return false }
            guard let h = Int(hgt.dropLast(2)) else { return false }
            if hgt.hasSuffix("cm") {
                guard (150...193).contains(h) else { return false }
            } else {
                guard (59...76).contains(h) else { return false }
            }
            
            guard let hcl = ps["hcl"] else { return false }
            guard hcl.first == "#" else { return false }
            guard hcl.count == 7 else { return false }
            guard hcl.dropFirst().allSatisfy(\.isHexDigit) else { return false }
            
            guard let ecl = ps["ecl"] else { return false }
            guard colors.contains(ecl) else { return false }
            
            guard let pid = ps["pid"] else { return false }
            guard pid.count == 9 else { return false }
            
            return true
        }
        
        return ("\(p1.count)", "\(p2.count)")
    }

}
