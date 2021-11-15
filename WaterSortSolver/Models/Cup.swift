//
//  Cup.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI

struct Cup {
    
    static func == (lhs: Cup, rhs: Cup) -> Bool {
        lhs.id == rhs.id
    }
    
    let MAX_COLORS: Int = 4
    
    var id: UUID = UUID()
    var pos: Int
    var colors: [CupColor]
    
    init(_ pos: Int, _ colors: [CupColor]) {
        self.pos = pos
        self.colors = colors
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func topColor() -> CupColor {
        for color in colors {
            if color != .clC {
                return color
            }
        }
        return .clC
    }
    
    func isEmpty() -> Bool {
        return colors.filter { $0 == .clC }.count == 4 || colors.count == 0
    }
    
    func hasSpace(for cells: Int) -> Bool {
        var count = 0
        for i in 0..<colors.count {
            if colors[i] == .clC {
                count += 1
            } else {
                return count >= cells
            }
        }
        return count >= cells
    }
    
    func cells(for color: CupColor) -> Int {
        var match: [CupColor] = []
        for i in 0..<colors.count {
            if colors[i] == .clC && match.count == 0 {
                continue
            }
            if colors[i] == color {
                match.append(colors[i])
            } else {
                break
            }
        }
        return match.count
    }
    
    mutating func removeAllColors() {
        colors.removeAll()
        while (colors.count < 4) {
            colors.insert(.clC, at: 0)
        }
    }
    
    func isSingleColor() -> Bool {
        let color = topColor()
        for c in colors {
            if c == .clC { continue }
            if c != color { return false }
        }
        return true
    }
    
}




