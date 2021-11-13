//
//  RejectedMovesVieew.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 08/11/2021.
//

import SwiftUI

struct RejectedMovesView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Rejected Moves")
                    .font(.headline)
                Spacer()
            }
            ScrollView(.vertical) {
                VStack(spacing: 2) {
                    ForEach (vm.rejectedMoves, id: \.id) { move in
                        HStack {
                            Text("\(move.from)")
                                .font(.caption)
                                .frame(width: 15)
                            Rectangle()
                                .foregroundColor(move.fromColor.color)
                                .frame(width: 20)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                                .frame(width: 15)
                            Text("\(move.into)")
                                .font(.caption)
                                .frame(width: 15)
                            Rectangle()
                                .foregroundColor(move.intoColor.color)
                                .frame(width: 20)
                            Spacer()
                        }
                        .frame(height: 20)
                    }
                }
            }
            Spacer()
        }
        
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.25))
        .cornerRadius(10)
    }
}

struct RejectedMovesView_Previews: PreviewProvider {
    static var previews: some View {
        RejectedMovesView()
    }
}
