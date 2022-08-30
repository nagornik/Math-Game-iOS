//
//  SettingsView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 30.08.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var logic: ViewModel
    
    @State private var showPhotoSheet = false
    @State private var image: UIImage? = nil
    
    
    @State var selectDifficulty = false
    @State var name = "Anton"
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
//                TopButtons()

                VStack(alignment: .leading) {
                    
                    profilePicture
                    
                    yourName
                    
                    difficulty
                        
                    
                    Button {
                        
                    } label: {
                        
                    }

                    
                    
                }
                .padding(.horizontal)
                
                
                Spacer()
                
            }
            
            
        }
        .animation(.spring(), value: selectDifficulty)
        
        
    }
    
    var profilePicture: some View {
        
        ZStack {
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        Text("Edit")
                            .font(.caption)
                            .foregroundColor(Color("text"))
                            .frame(maxWidth: .infinity)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
            } else {
                ZStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("text"))
                        .frame(width: 50, height: 50)
                }
            }
            
        }
        .frame(width: 130, height: 130)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color("text"), style: StrokeStyle(lineWidth: 2))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onTapGesture {
            showPhotoSheet = true
        }
        .fullScreenCover(isPresented: $showPhotoSheet) {
            PhotoPicker(filter: .images, limit: 1) { results in
                PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                    if let error = errorOrNil {
                        print(error)
                    }
                    if let images = imagesOrNil {
                        if let first = images.first {
                            print(first)
                            image = first
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    var yourName: some View {
        
        HStack {
            
            Text("Your name")
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("text"))
                .transition(.move(edge: .leading))
                .padding()
            
            HStack {
                
                TextField("Name", text: $name)
                
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        name = ""
                    }
            }
            .foregroundColor(Color("text"))
            .padding()
            .background(Color(.gray).opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
    var difficulty: some View {
        
        HStack {
            
            if selectDifficulty {
                
                Spacer()
                
                VStack {
                    ForEach(Difficulties.allCases, id:\.self) { diff in
                        TextButton(text: diff.rawValue, size: 14)
                            .onTapGesture {
                                logic.difficulty = diff
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectDifficulty = false
                                }
                            }
                    }
                    .padding(.vertical, 4)
                }
                
                Spacer()
                
            } else {
                
                Text("Difficulty")
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(Color("text"))
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .padding()
                
                TextButton(text: logic.difficulty.rawValue, size: 14)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectDifficulty = true
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .frame(maxWidth: .infinity)
            }
            
        }
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
    }
}
