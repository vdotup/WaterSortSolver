//
//  CupMove.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 13/11/2021.
//

import SwiftUI

struct CupMove: Equatable {
    var id: UUID = UUID()
    var from: Int
    var into: Int
    var fromColor: CupColor
    var intoColor: CupColor
    var cells: Int
    
    static func == (lhs: CupMove, rhs: CupMove) -> Bool {
        return lhs.from == rhs.from && lhs.into == rhs.into && lhs.fromColor == rhs.fromColor && lhs.intoColor == rhs.intoColor
    }
    
    init(id: UUID = UUID(), from: Int, into: Int, fromColor: CupColor, intoColor: CupColor, cells: Int) {
        self.id = id
        self.from = from
        self.into = into
        self.fromColor = fromColor
        self.intoColor = intoColor
        self.cells = cells
    }
}
