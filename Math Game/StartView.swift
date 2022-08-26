//
//  StartView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.05.2022.
//

import SwiftUI

struct StartView: View {
    
    @State var progressValue: Float = 0.0
    
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
         
        Color(UIColor(hue:0.12, saturation:0.51, brightness:0.95, alpha:1.00)).ignoresSafeArea()
        Color(UIColor(hue:0.48, saturation:0.27, brightness:0.85, alpha:1.00))
                .rotationEffect(Angle(degrees: 45))
                .ignoresSafeArea()

            VStack {
                
                Spacer()
                
                Text("Math Game")
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .font(.system(size: 55, weight: .bold))
                    .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    .padding(.bottom, 50.0)
                
                
                Spacer()
                
                
                
                VStack {
                    TimerView(timeRemaning: $timeRemaining, progress: $progressValue)
                        .frame(width: 200.0, height: 200.0)
                        .padding(40.0)
                        .animation(.easeInOut(duration: 5), value: progressValue)
                }
                .onAppear {
                    progressValue = 1.0
                }
                .onReceive(timer) { time in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
                
                        

                
                
                
                
                
                Spacer()
                
                Button {
                    progressValue = 0
                } label: {
                    
                    Text("Start")
                        .frame(width: 140, height: 80)
                        .font(.system(size: 40, weight: .bold))
                        .background(Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)))
                        .foregroundColor(Color(UIColor(hue:0.09, saturation:0.06, brightness:1.00, alpha:1.00)))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .padding()
                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                        
                }
                .padding(.bottom, 90)
                
            }
            
            
            
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
