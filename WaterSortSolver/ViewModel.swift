//
//  ViewModel.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    
    let MIN_CUPS = 4
    let MAX_CUPS = 14
    let colors: [CupColor] = [.blC, .g1C, .cyC, .puC, .piC, .g2C, .grC, .orC, .reC, .brC, .yeC, .g3C]
    var current: Int = 0
    
    @Published var selectedFrom: Int = -1
    @Published var selectedInto: Int = -1
    @Published var editing: Bool = true
    @Published var started: Bool = false
    @Published var reject: Bool = true
    @Published var solving: Bool = false
    @Published var tries: Int = 0
    @Published var solves: Int = 0
    @Published var bestSolve: Int = 0
    @Published var bestMoves: Int = 0
    
    @Published var rejectedMoves: [CupMove] = []
    @Published var moves: [CupMove] = []
    
    @Published var initCups: [Cup] = []
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
        cups.append(Cup(9, [.brC, .yeC, .grC, .g2C]))
        cups.append(Cup(10, [.grC, .yeC, .g3C, .blC]))
        cups.append(Cup(11, [.g2C, .cyC, .piC, .orC]))
        cups.append(Cup(12, [.clC, .clC, .clC, .clC]))
        cups.append(Cup(13, [.clC, .clC, .clC, .clC]))
        
        initCups = Array(cups)
    }
    
    func addCup(_ cup: Cup) {
        if cups.count >= MAX_CUPS { return }
        guard let index = cups.firstIndex(where: { $0 == cup }) else { return }
        cups.insert(Cup(cups.count, [.clC, .clC, .clC, .clC]), at: index)
    }
    
    func removeCup(_ cup: Cup) {
        if cups.count <= MIN_CUPS { return }
        guard let index = cups.firstIndex(where: { $0 == cup }) else { return }
        cups.remove(at: index)
    }
    
    func addColor(_ color: CupColor, _ cup: Cup) {
        guard let index = cups.firstIndex(where: { $0 == cup }) else { return }
        cups[index].colors.removeAll(where: { $0 == .clC })
        if cups[index].colors.count >= 4 { return }
        cups[index].colors.append(color)
        while (cups[index].colors.count < 4) {
            cups[index].colors.insert(.clC, at: 0)
        }
    }
    
    func removeColor(_ color: CupColor, _ cup: Cup) {
        if started {
            return
        }
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
        guard let index = moves.firstIndex(where: { $0 == move }) else { return }
        moves.remove(at: index)
    }
    
    func findNearestMove() -> CupMove? {
        //print("----------FIND NEAREST MOVE----------")
        for fromCup in cups.shuffled() {
            
            // if empty cup skip
            if fromCup.topColor() == .clC {
                continue
            }
            
            // store top color, and cells
            let fromCupColor = fromCup.topColor()
            let fromCupCells = fromCup.cells(for: fromCupColor)
            //print("OCUP:", oCup.pos, "COLOR:", oCupColor.name, "CELLS:", oCupCells)
            for intoCup in cups.shuffled() {
                if fromCup == intoCup {
                    continue
                }
                if fromCup.cells(for: .clC) == 4 {
                    print(" ALL CLC")
                    continue
                }
                
                let intoCupColor = intoCup.topColor()
                //let iCupCells = iCup.cells(for: iCupColor)
                if (intoCupColor != fromCupColor && !intoCup.isEmpty()) {
                    continue
                }
                if !intoCup.hasSpace(for: fromCupCells) {
                    continue
                }
                //print(" ICUP:",iCup.pos, "COLOR", iCupColor.name , "HAS SPACE:", iCup.hasSpace(for: oCupCells))
                
                guard let fromIndex = cups.firstIndex(where: { $0 == fromCup }) else { return nil }
                guard let intoIndex = cups.firstIndex(where: { $0 == intoCup }) else { return nil }
                let move = CupMove(from: fromIndex, into: intoIndex, fromColor: fromCup.topColor(), intoColor: intoCup.topColor(), cells: fromCupCells)
                return move
            }
        }
        return nil
    }
    
    // next move
    func next() {
        guard let move = findNearestMove() else { return }
        moves.append(move)
        transfer(move: move)
    }
    
    // reset everything to start state
    func reset() {
        cups.removeAll()
        cups.append(contentsOf: initCups)
        initCups = Array(cups)
        moves.removeAll()
    }
    
    // undo last move
    func undo() {
        guard let lastMove = moves.last else { return }
        moves.removeLast()
        transfer(move: CupMove(from: lastMove.into, into: lastMove.from, fromColor: lastMove.intoColor, intoColor: lastMove.fromColor, cells: lastMove.cells))
    }
    
    // apply the passed CupMove
    func transfer(move: CupMove) {
        // remove clear color from both cups first
        cups[move.into].colors.removeAll(where: { $0 == .clC })
        cups[move.from].colors.removeAll(where: { $0 == .clC })
        
        var movedColors: [CupColor] = []
        for _ in 0..<move.cells {
            movedColors.append(cups[move.from].colors.removeFirst())
        }
        cups[move.into].colors.insert(contentsOf: movedColors, at: 0)
        
        // add clear color until max is reached
        while cups[move.into].colors.count < 4 {
            cups[move.into].colors.insert(.clC, at: 0)
        }
        while (cups[move.from].colors.count < 4) {
            cups[move.from].colors.insert(.clC, at: 0)
        }
    }
    
}
