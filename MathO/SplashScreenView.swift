//
//  SplashScreenView.swift
//  MathO
//
//  Created by Vincent Gunawan on 29/03/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea(.all)
            VStack{
                Image("splash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
