//
//  ViewModel.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    let MIN_CUPS = 4
    let MAX_CUPS = 14
    let colors: [CupColor] = [.blC, .g1C, .cyC, .puC, .piC, .g2C, .grC, .orC, .reC, .brC, .yeC, .g3C]
    var current: Int = 0
    @Published var selectedFrom: Int = -1
    @Published var selectedInto: Int = -1
    @Published var editing: Bool = true
    @Published var started: Bool = false
    
    @Published var moves: [CupMove] = [
//        CupMove(from: 0, into: 3),
//        CupMove(from: 1, into: 3),
//        CupMove(from: 0, into: 4),
//        CupMove(from: 1, into: 4),
//        CupMove(from: 1, into: 0),
//        CupMove(from: 4, into: 1),
//        CupMove(from: 2, into: 3),
//        CupMove(from: 2, into: 4),
//        CupMove(from: 0, into: 1),
//        CupMove(from: 2, into: 1),
//        CupMove(from: 0, into: 3),
//        CupMove(from: 2, into: 3),
//        CupMove(from: 2, into: 4),
    ]
    var move: CupMove {
        return moves[current]
    }
    
    @Published var cups: [Cup] = []
    var cancellables = [AnyCancellable]()
    
    init() {
        cups.append(Cup(0, [.blC, .g1C, .cyC, .cyC])) //
        cups.append(Cup(1, [.puC, .piC, .g2C, .grC])) //
        cups.append(Cup(2, [.orC, .puC, .reC, .brC])) //
        cups.append(Cup(3, [.orC, .piC, .reC, .orC])) //
        cups.append(Cup(4, [.g1C, .reC, .yeC, .blC])) //
        cups.append(Cup(5, [.yeC, .g1C, .brC, .g1C])) //
        cups.append(Cup(6, [.brC, .puC, .reC, .g3C])) //
        
        cups.append(Cup(7, [.g3C, .puC, .piC, .g3C])) //
        cups.append(Cup(8, [.g2C, .grC, .cyC, .blC])) //
        cups.append(Cup(9, [.brC, .yeC, .grC, .unC]))
        cups.append(Cup(10, [.grC, .yeC, .g3C, .unC]))
        cups.append(Cup(11, [.g2C, .cyC, .piC, .unC]))
        cups.append(Cup(12, [.clC, .clC, .clC, .clC]))
        cups.append(Cup(13, [.clC, .clC, .clC, .clC]))
        
//        cups.append(Cup(0, [.blC, .reC, .orC, .blC]))
//        cups.append(Cup(1, [.blC, .reC, .orC, .orC]))
//        cups.append(Cup(2, [.reC, .orC, .blC, .reC]))
//        cups.append(Cup(3, [.clC, .clC, .clC, .clC]))
//        cups.append(Cup(4, [.clC, .clC, .clC, .clC]))
        
        self.cups.forEach( {
            let c = $0.objectWillChange.sink(receiveValue: { self.objectWillChange.send() })
            self.cancellables.append(c)
        })
    }
    
    func selectMove(_ cup: Cup) {
        guard let index = cups.firstIndex(where: { $0 == cup }) else {
            print("index not found")
            return
        }
        
        if selectedFrom == -1 {
            selectedFrom = index
            return
        }
        else if selectedInto == -1 {
            selectedInto = index
            if selectedFrom == selectedInto {
                print("can't move to same cup")
                selectedInto = -1
                return
            }
            let move = CupMove(from: selectedFrom, into: selectedInto)
            moves.append(move)
            selectedInto = -1
            selectedFrom = -1
        }
    }
    
    func addColor(_ color: CupColor, _ cup: Cup) {
        guard let index = cups.firstIndex(where: { $0 == cup }) else {
            print("index not found")
            return
        }
        cups[index].colors.removeAll(where: { $0 == .clC })
        if cups[index].colors.count >= 4 {
            print("max colors reached")
            return
        }
        cups[index].colors.append(color)
        while (cups[index].colors.count < 4) {
            cups[index].colors.insert(.clC, at: 0)
        }
    }
    
    func addCup(_ cup: Cup) {
        if cups.count >= MAX_CUPS {
            print("max cups reached")
            return
        }
        guard let index = cups.firstIndex(where: { $0 == cup }) else {
            print("index not found")
            return
        }
        cups.insert(Cup(cups.count, [.clC, .clC, .clC, .clC]), at: index)
    }
    
    func removeCup(_ cup: Cup) {
        if cups.count <= MIN_CUPS {
            print("min cups reached")
            return
        }
        guard let index = cups.firstIndex(where: { $0 == cup }) else {
            print("index not found")
            return
        }
        cups.remove(at: index)
    }
    
    func removeColor(_ color: CupColor, _ cup: Cup) {
        guard let cupIndex = cups.firstIndex(where: { $0 == cup }) else {
            print("index not found")
            return
        }
        guard let colorIndex = cup.colors.firstIndex(where: { $0 == color }) else {
            print("index not found")
            return
        }
        cups[cupIndex].colors.remove(at: colorIndex)
        if cups[cupIndex].colors.count >= 4 {
            print("max colors reached")
            return
        }
        while (cups[cupIndex].colors.count < 4) {
            cups[cupIndex].colors.insert(.clC, at: 0)
        }
    }
    
    func removeMove(_ move: CupMove) {
        guard let index = moves.firstIndex(where: { $0 == move }) else {
            print("index not found")
            return
        }
        moves.remove(at: index)
    }
    
    func getTotals() {
        var totals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for i in cups {
            for j in i.colors {
                if let index = colors.firstIndex(of: j) {
                    totals[index] += 1
                }
            }
        }
        print(totals)
    }
    
    func start() {
        started = true
        current = 0
        transfer(from: move.from, into: move.into)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.next()
        }
    }
    
    func next() {
        current += 1
        if current == moves.count {
            finish()
            return
        }
        transfer(from: move.from, into: move.into)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.next()
        }
    }
    
    func finish() {
        print("FINISH")
    }
    
    func transfer(from: Int, into: Int) {
        
        // prevent invalid move
        
        print(from, into)
        cups[into].colors.removeAll(where: { $0 == .clC })
        cups[from].colors.removeAll(where: { $0 == .clC })
        
        var movedColors: [CupColor] = []
            let color = cups[from].colors[0].color
        print(printColors(cups[from].colors))
        
        while cups[from].colors.count != 0 && cups[from].colors[0].color == color {
            movedColors.append(cups[from].colors.removeFirst())
        }
        
        if cups[into].colors.count != 0 && cups[into].colors[0].color != color {
            print("INVALID MOVE")
            return
        }
        
        cups[into].colors.insert(contentsOf: movedColors, at: 0)
        
        while (cups[into].colors.count < 4) {
            cups[into].colors.insert(.clC, at: 0)
        }
        
        while (cups[from].colors.count < 4) {
            cups[from].colors.insert(.clC, at: 0)
        }
        
        //print(from, printColors(cups[from].colors))
        //print(into, printColors(cups[into].colors))
    }
    
    func printColors(_ colors: [CupColor]) -> String {
        var result = "\(colors.count) "
        for c in colors {
            result.append(c.name)
            result.append(", ")
        }
        return result
    }
}
