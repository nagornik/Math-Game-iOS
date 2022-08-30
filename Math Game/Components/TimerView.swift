//
//  TimerView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.05.2022.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var timeRemaning: Float
    @Binding var progress: Float
    
    var body: some View {
        
        ZStack {
            
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(Color("buttonBack"))
            
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 20.0 ))
                        .overlay(content: {
                            AngularGradient(gradient: Gradient(colors: [Color("buttonBack"), .red, Color("buttonBack")]), center: .center)
                                .mask {
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                }
                        })
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.spring(), value: progress)
                        
            Text("\(max("0", timeRemaning.formatted())) sec")
                        .font(.system(size: 35, weight: .semibold))
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
//                        .animation(.linear(duration: 5), value: progress)
//                        .onTapGesture {
//                                progress += 0.1
//                        }
                        
        
        }
        
        
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timeRemaning: .constant(4), progress: .constant(0.370))
    }
}
