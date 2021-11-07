//
//  ContentView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI

struct Main: View {
    
    let MAX_HEIGHT: CGFloat = 200
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 1) {
                ForEach(vm.cups, id: \.id) { cup in
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ForEach(cup.colors, id: \.id) { color in
                                if color == .unC {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(color.color)
                                            .border(.black, width: 1)
                                        Text("?")
                                            .font(.system(size: 25, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .onTapGesture {
                                        vm.removeColor(color, cup)
                                    }
                                } else {
                                    Rectangle()
                                        .foregroundColor(color.color)
                                        .border(.black, width: 1)
                                        .onTapGesture {
                                            vm.removeColor(color, cup)
                                        }
                                }
                            }
                        }
                        .frame(height: MAX_HEIGHT)
                        
                        Text("\(cup.pos)")
                            .foregroundColor(.black)
                            .font(.caption)
                        
                        if vm.editing && !vm.started {
                            VStack {
                                Button(action: { vm.addCup(cup) }) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.green)
                                        Text("+")
                                            .font(.caption)
                                    }
                                }
                                Button(action: { vm.removeCup(cup) }) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.red)
                                        Text("-")
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(2)
                            .frame(height: 50)
                        }
                        
                            if !vm.editing && !vm.started {
                                Button(action: { vm.selectMove(cup) }) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.green)
                                        Text("!")
                                            .font(.caption)
                                    }
                                }
                                .padding(2)
                                .frame(height: 50)
                            }
                        
                        if vm.editing && !vm.started {
                            VStack(spacing: 2) {
                                ForEach (vm.colors, id: \.id) { color in
                                    Button(action: { vm.addColor(color, cup) }) {
                                        Circle()
                                            .foregroundColor(color.color)
                                    }
                                }
                            }
                            .padding(2)
                            .frame(height: 300)
                        }
                    }
                    .border(.black, width: 1)
                }
            }
            if !vm.editing {
                ScrollView(.vertical) {
                    VStack(spacing: 2) {
                        ForEach (vm.moves, id: \.id) { move in
                            HStack {
                                Button(action: { vm.removeMove(move) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                Text("\(move.from)")
                                    .font(.caption)
                                Image(systemName: "arrow.right")
                                Text("\(move.into)")
                                    .font(.caption)
                                Spacer()
                            }
                        }
                    }
                }
            }
            Spacer()
            HStack {
                if vm.editing && !vm.started {
                    Button("Moves", action: { vm.editing = false })
                } else if !vm.editing && !vm.started {
                    Button("Start", action: vm.start)
                        .disabled(vm.moves.count == 0)
                } else if vm.started {
                    Button("Totals", action: vm.getTotals)
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
