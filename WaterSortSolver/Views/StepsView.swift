//
//  StepsView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 15/11/2021.
//

import SwiftUI

struct StepsView: View {
    
    @EnvironmentObject private var vm: ViewModel
    @State private var current: Int = 0
    var move: CupMove { vm.moves[current] }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(move.from)")
                    .font(.title)
                    .frame(width: 60)
                VStack(spacing: 2) {
                    ForEach(0..<move.cells, id: \.self) { _ in
                        Rectangle()
                            .foregroundColor(move.fromColor.color)
                            .frame(width: 60)
                    }
                }
                Image(systemName: "arrow.right")
                    .font(.title)
                    .frame(width: 60)
                Text("\(move.into)")
                    .font(.title)
                    .frame(width: 60)
                Rectangle()
                    .foregroundColor(move.intoColor.color)
                    .frame(width: 60)
                Spacer()
            }
            .frame(height: 60)
            Spacer()
            HStack {
                Button(action: { current -= 1 }) {
                    Label("prev", systemImage: "chevron.left")
                        .labelsHidden()
                }
                .buttonStyle(.bordered)
                .font(.largeTitle)
                .tint(.blue)
                .disabled(current == 0)
                Spacer()
                Text("\(current+1) / \(vm.moves.count)")
                    .font(.largeTitle)
                Spacer()
                Button(action: { current += 1 }) {
                    Label("next", systemImage: "chevron.right")
                        .labelsHidden()
                }
                .buttonStyle(.bordered)
                .font(.largeTitle)
                .tint(.blue)
                .disabled(current == vm.moves.count - 1)
            }
        }
        .padding()
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
