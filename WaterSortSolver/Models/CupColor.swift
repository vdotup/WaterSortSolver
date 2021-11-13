//
//  CupColor.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 13/11/2021.
//

import SwiftUI

struct CupColor: Equatable {
    
    static func == (lhs: CupColor, rhs: CupColor) -> Bool {
        lhs.color == rhs.color
    }
    
    var id: UUID = UUID()
    var color: Color
    var name: String
    
    init(id: UUID = UUID(), _ color: Color, _ name: String = "") {
        self.id = id
        self.color = color
        self.name = name
    }
    
    public static var blC: CupColor { return CupColor(Color.init(red: 56/255, green: 46/255, blue: 187/255), "blue") }
    public static var puC: CupColor { return CupColor(Color.init(red: 104/255, green: 48/255, blue: 141/255), "purple") }
    public static var orC: CupColor { return CupColor(Color.init(red: 218/255, green: 144/255, blue: 81/255), "orange") }
    public static var g1C: CupColor { return CupColor(Color.init(red: 46/255, green: 100/255, blue: 57/255), "green1") }
    public static var g2C: CupColor { return CupColor(Color.init(red: 126/255, green: 149/255, blue: 48/255), "green2") }
    public static var g3C: CupColor { return CupColor(Color.init(red: 129/255, green: 211/255, blue: 132/255), "green3") }
    public static var yeC: CupColor { return CupColor(Color.init(red: 236/255, green: 218/255, blue: 109/255), "yellow") }
    public static var brC: CupColor { return CupColor(Color.init(red: 118/255, green: 77/255, blue: 26/255), "brown") }
    public static var grC: CupColor { return CupColor(Color.init(red: 98/255, green: 100/255, blue: 100/255), "gray") }
    public static var piC: CupColor { return CupColor(Color.init(red: 218/255, green: 103/255, blue: 124/255), "pink") }
    public static var cyC: CupColor { return CupColor(Color.init(red: 103/255, green: 161/255, blue: 223/255), "cyan") }
    public static var reC: CupColor { return CupColor(Color.init(red: 255/255, green: 0/255, blue: 0/255), "red") }
    public static var clC: CupColor { return CupColor(Color.clear, "clear") }
    public static var unC: CupColor { return CupColor(Color.teal, "unknown") }
    
}
