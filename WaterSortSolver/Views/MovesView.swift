//
//  MovesView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 08/11/2021.
//

import SwiftUI

struct MovesView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Moves [\(vm.moves.count)]")
                    .font(.headline)
                Spacer()
            }
            ScrollView(.vertical) {
                VStack(spacing: 2) {
                    ForEach (vm.moves, id: \.id) { move in
                        HStack {
                            Text("\(move.from)")
                                .font(.caption)
                                .frame(width: 15)
                            ZStack {
                                Rectangle()
                                    .foregroundColor(move.fromColor.color)
                                    .frame(width: 20)
                                Text("\(move.cells)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .frame(width: 15)
                            }
                            Image(systemName: "arrow.right")
                                .font(.caption)
                                .frame(width: 15)
                            Text("\(move.into)")
                                .font(.caption)
                                .frame(width: 15)
                            Rectangle()
                                .foregroundColor(move.intoColor.color)
                                .frame(width: 20)
                            ZStack {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: 20)
                                Text("\(move.possibleMoves)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .frame(width: 15)
                            }
                            Spacer()
                        }
                        .frame(height: 20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.25))
        .cornerRadius(10)
    }
}

struct MovesView_Previews: PreviewProvider {
    static var previews: some View {
        MovesView()
    }
}
