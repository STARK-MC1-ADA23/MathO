//
//  ExplainView.swift
//  MathO
//
//  Created by Petrus Sinaga on 05/04/23.
//

import SwiftUI


//
//struct ExplainView: View {
//    @State var currentStep = 0
//    
//    let steps = ["Step 1", "Step 2", "Step 3", "Step 4"]
//    
//    let ll: CGFloat
//    
//    init() {
//        self.ll = CGFloat(50 + (5-steps.count) * 30)
//    }
//    
//    var body: some View {
//        
//        ZStack {
//            
//            Spacer()
//            
//            VStack {
//                
//                Text("1 + 6 x 3 - 1")
//                    .font(.system(size: 32, design: .rounded))
//                    .bold()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .frame(width: 335, height: 84)
//                            .foregroundColor(Color.white)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.black, lineWidth: 3)
//                            )
//                    )
//                    .padding(24)
//                
//                CustomIndicator(numberOfStep: steps.count, lengthLine: CGFloat(ll), currentStep: $currentStep)
//                    .padding(24)
//                
//                
//                VStack {
//                    Text("Kamu perlu menjawab pertanyaan ini")
//                        .font(.system(size: 18, design: .rounded))
//                        .bold()
//                    Text("6 x 3")
//                        .font(.system(size: 48, design: .rounded))
//                        .bold()
//                        .padding(.top, 1)
//                }
//                .padding(.horizontal, 80)
//                .padding(.vertical, 24)
//                .frame(maxWidth: .infinity)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(Color("celestialBlue"))
//                )
//                .padding([.leading, .bottom, .trailing], 24)
//                
//                SegitigaAjaibView()
//                
//                
//            }
//        }
//    }
//}
//
//struct ExplainView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExplainView()
//    }
//}

struct CustomIndicator1: View {
    let numberOfStep: Int
    let lengthLine: CGFloat
    @Binding var currentStep: Int
    
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfStep) { index in
                Button {
                    currentStep = index
                } label: {
                    Circle()
                        .fill(currentStep > index ? Color.blue : Color("water"))
                        .frame(width: 20, height: 20)
                        .overlay (
                            Circle()
                                .stroke(Color.blue, lineWidth: 10)
                                .opacity(index <= currentStep ? 1 : 0)
                        )
                }
                
                
                if index != numberOfStep - 1 {
                    Rectangle()
                        .fill(currentStep >= index ?
                              Color.blue : Color("water"))
                        .frame(width: lengthLine, height: 5)
                }
                
            }
        }
    }
}


