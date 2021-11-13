//
//  ContentView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI

struct Main: View {
    
    let MAX_HEIGHT: CGFloat = 100
    @EnvironmentObject var vm: ViewModel
    @State var showingCupsEdit: Bool = false
    
    var body: some View {
        ZStack {
            if vm.solving {
                VStack(spacing: 10) {
                    ProgressView()
                        .tint(.red)
                    VStack(spacing: 5) {
                        Text("Tries: \(vm.tries)")
                            .frame(width: 100)
                        Text("Solves: \(vm.solves)")
                            .frame(width: 100)
                        Text("Best: \(vm.bestSolve)")
                            .frame(width: 100)
                        Text("Best Moves: \(vm.bestMoves)")
                            .frame(width: 100)
                        Text("Rejected: \(vm.rejectedMoves.count)")
                            .frame(width: 100)
                    }
                    .font(.caption)
                    
                    Button("Stop", action: vm.reset)
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .font(.caption)
                }
            } else {
                VStack {
                    VStack {
                        HStack {
                            Button("Edit Cups", action: { showingCupsEdit.toggle() })
                                .font(.caption)
                                .buttonStyle(.bordered)
                                .tint(.orange)
                            Spacer()
                        }
                        HStack(spacing: 1) {
                            ForEach(vm.cups, id: \.id) { cup in
                                VStack(spacing: 0) {
                                    VStack(spacing: -1) {
                                        ForEach(cup.colors, id: \.id) { color in
                                            if color == .unC {
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(color.color)
                                                        .border(.black, width: 1)
                                                    Text("?")
                                                        .font(.system(size: 15, weight: .black, design: .rounded))
                                                        .foregroundColor(.white)
                                                }
                                            } else {
                                                Rectangle()
                                                    .foregroundColor(color.color)
                                                    .border(.black, width: 1)
                                            }
                                        }
                                    }
                                    .frame(height: MAX_HEIGHT)
                                    Text("\(cup.pos)")
                                        .foregroundColor(.black)
                                        .font(.caption)
                                }
                                .border(.black, width: 1)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(10)
                    
                    HStack {
                        MovesView()
                        RejectedMovesView()
                    }
                    
                    
                    Spacer()
                    HStack {
                        Button("Start", action: {})
                            .buttonStyle(.bordered)
                            .font(.caption)
                            .tint(.green)
                            .disabled(true)
                        Spacer()
                        Button("Undo", action: vm.undo)
                            .buttonStyle(.bordered)
                            .font(.caption)
                            .tint(.green)
                        Spacer()
                        Button("Next", action: vm.next)
                            .buttonStyle(.bordered)
                            .font(.caption)
                            .tint(.green)
                        Spacer()
                        Button("Reset", action: vm.reset)
                            .buttonStyle(.bordered)
                            .font(.caption)
                            .tint(.red)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingCupsEdit) {
            CupsEditView()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
