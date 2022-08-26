//
//  TimerView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.05.2022.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var timeRemaning: Int
    @Binding var progress: Float
//    @State var progress: Float = 0.0
    
    var body: some View {
        
        ZStack {
            
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
//                        .foregroundColor(.red.opacity(Double(progress)))
                        .foregroundColor(Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)))
            
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 20.0 ))
                        
//                        .opacity(Double(progress))
//                        .foregroundColor(.red.opacity(Double(progress)))
//                        .foregroundColor(Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)))
//                        .gradientForeground(colors: [Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)), Color.red])
                        
                        .overlay(content: {
                            AngularGradient(gradient: Gradient(colors: [Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)), .red]), center: .center)
                                .mask {
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                }
                        })
                        
                        
//                        .foregroundColor()
//                        .linearGradient(colors: [Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)), Color.red], startPoint: .top, endPoint: .bottom)
                        
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear(duration: 5), value: progress)
                        
                    Text("\(timeRemaning) sec")
                        .font(.system(size: 35, weight: .semibold))
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                        .animation(.linear(duration: 5), value: progress)
                        .onTapGesture {
                                progress += 0.1
                        }
                        
        
        }
        
        
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timeRemaning: .constant(4), progress: .constant(0.370))
//        TimerView()
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
//            .mask(Circle())
//            .padding(-50)
    }
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {

            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self

            )
        }
    }
}
