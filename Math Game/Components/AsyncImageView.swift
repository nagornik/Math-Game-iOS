//
//  AsyncImageView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 02.09.2022.
//

import SwiftUI

struct AsyncImageView: View {
    
    
    @EnvironmentObject var database: DatabaseService
    
    var imageUrlString: String
    
    var body: some View {
        
        ZStack {
            
            if let cachedImage = database.getImage(forKey: imageUrlString) {
                
                cachedImage
                    .resizable()
                    .scaledToFill()
                    .clipped()
                
            } else {
                
                let photoUrl = URL(string: imageUrlString)
                
                AsyncImage(url: photoUrl) { phase in
                    
                    switch phase {
                            
                        case AsyncImagePhase.empty:
                            
                            ZStack {
                                ProgressView()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        case AsyncImagePhase.success(let image):
                            
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .onAppear {
                                    database.setImage(image: image, forKey: imageUrlString)
                                }
                            
                        case AsyncImagePhase.failure:
                            GeometryReader { geo in
                                ZStack {
                                    Color(.gray)
                                        .opacity(0.3)
                                    Image(systemName: "photo.fill.on.rectangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.primary.opacity(0.7))
                                        .frame(width: geo.size.width/3, height: geo.size.height/3, alignment: .center)
                                }
                            }
                    }
                }
                
            }
        }
    }
    
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageUrlString: "https://randomuser.me/api/portraits/men/15.jpg")
            .environmentObject(DatabaseService())
    }
}
