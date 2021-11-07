//
//  CupView.swift
//  WaterSortSolver
//
//  Created by Abdurrahman Alfudeghi on 03/11/2021.
//

import SwiftUI

struct CupView: View {
    
    let MAX_HEIGHT: CGFloat = 200
    var cup: Cup
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Spacer()
                ForEach(cup.colors, id: \.id) { color in
                    if color == .unC {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .border(.black, width: 1)
                            Text("?")
                                .font(.system(size: 25, weight: .black, design: .rounded))
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
            .border(.black, width: 1)
        }
    }
}

struct CupView_Previews: PreviewProvider {
    static var previews: some View {
        CupView(cup: Cup(0, [.blC, .brC, .yeC, .orC]))
    }
}
