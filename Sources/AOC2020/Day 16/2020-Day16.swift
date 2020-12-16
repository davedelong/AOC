//
//  Day16.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day16: Day {

    let field: Regex = #"(.+?): (\d+)-(\d+) or (\d+)-(\d+)"#
    
    struct Field: Hashable {
        let name: String
        let ranges: Array<ClosedRange<Int>>
        
        func contains(_ value: Int) -> Bool {
            return ranges.any { $0.contains(value) }
        }
    }
    
    struct Ticket {
        let values: Array<Int>
    }
    
    lazy var fields: Array<Field> = {
        return input.rawLines.compactMap { line -> Field? in
            guard let m = field.match(line) else { return nil }
            return Field(name: m[1]!,
                         ranges: [
                            m[int: 2]!...m[int: 3]!,
                            m[int: 4]!...m[int: 5]!,
                         ])
        }
    }()
    
    lazy var tickets: Array<Ticket> = {
        input.lines.dropFirst(22).compactMap { line -> Ticket? in
            let ints = line.integers
            guard ints.count == 20 else { return nil }
            return Ticket(values: ints)
        }
    }()
    
    override func run() -> (String, String) {
        var invalidValues = Array<Int>()
        var valid = Array<Ticket>()
        
        for ticket in tickets {
            let invalidTicketValues = ticket.values.filter { value -> Bool in
                let invalidCount = fields.count(where: { $0.contains(value) == false })
                if invalidCount == fields.count { return true }
                return false
            }
            invalidValues.append(contentsOf: invalidTicketValues)
            if invalidTicketValues.isEmpty { valid.append(ticket) }
        }
        
        var mappedFields = Dictionary<Int, Set<Field>>()
        for i in 0 ..< 20 { mappedFields[i] = Set(fields) }
        
        while mappedFields.values.contains(where: { $0.count > 1 }) {
            for ticket in valid {
                for (idx, value) in ticket.values.enumerated() {
                    let possible = mappedFields[idx] ?? []
                    let narrowed = possible.filter { $0.contains(value) }
                    mappedFields[idx] = narrowed
                    if narrowed.count == 1 {
                        for k in mappedFields.keys {
                            guard k != idx else { continue }
                            mappedFields[k]?.remove(narrowed.first!)
                        }
                    }
                    
                    /*
                     // this alternative version will subsequently filter out any field that is identified
                     // in the course of narrowing down this field
                     
                     // it runs in about the same amount of time
                     if narrowed.count == 1 {
                         var pop: Array<(Int, Field)> = [(idx, narrowed.first!)]
                         while let (fieldIdx, field) = pop.first {
                             pop.removeFirst()
                             for k in mappedFields.keys {
                                 guard k != fieldIdx else { continue }
                                 if let _ = mappedFields[k]?.remove(field), mappedFields[k]?.count == 1 {
                                     pop.append((k, mappedFields[k]!.first!))
                                 }
                             }
                         }
                     }
                     
                     */
                }
                
                if mappedFields.count(where: { $0.value.count == 1 }) == mappedFields.count { break }
            }
        }
        
        let departureFields = Set(fields.filter { $0.name.hasPrefix("departure") })
        let mapping = mappedFields.mapValues { $0.first! }.filter { departureFields.contains($0.value) }
        
        let myValues = mapping.keys.map { tickets[0].values[$0] }
        
        return ("\(invalidValues.sum)", "\(myValues.product)")
    }

}
