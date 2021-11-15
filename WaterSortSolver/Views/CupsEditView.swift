//
//  CupsEditView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 07/11/2021.
//

import SwiftUI

struct CupsEditView: View {
    
    @EnvironmentObject var vm: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
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
                        .frame(height: 100)
                        
                        Text("\(cup.pos)")
                            .foregroundColor(.black)
                            .font(.caption)
                        
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
                    .border(.black, width: 1)
                }
            }
            HStack {
                Button("Remove All Colors", action: { for i in 0..<vm.cups.count { vm.cups[i].removeAllColors() } })
                    .buttonStyle(.bordered)
                    .font(.caption)
                    .tint(.brown)
                Spacer()
                Button("Done", action: { presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(.bordered)
                    .font(.caption)
                    .tint(.blue)
                    .disabled(!vm.validate())
            }
            .padding()
            .background(Color.gray.opacity(0.25))
            .cornerRadius(10)
            Spacer()
            
        }
        .padding()
    }
}

struct CupsEditView_Previews: PreviewProvider {
    static var previews: some View {
        CupsEditView()
    }
}
