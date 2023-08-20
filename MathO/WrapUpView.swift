//
//  WrapUpView.swift
//  MathO
//
//  Created by Petrus Sinaga on 05/04/23.
//

import SwiftUI

struct WrapUpView: View {
    var question: Math
    func getOperatorPronounce(operation: String) -> String {
        let ops = operation.components(separatedBy: " ")[1]
        switch ops {
        case "x":
            return "Perkalian"
        case ":":
            return "Pembagian"
        case "+":
            return "Pertambahan"
        case "-":
            return "Pengurangan"
        default:
            return ""
        }

    }
    var body: some View {
            VStack {
                VStack {
                    
                    Text(question.stringQuestion)
                        .font(.system(size: 500))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("celestialBlue"))
                )
                .padding([.leading, .bottom, .trailing], 12)
                ForEach(0..<question.solution.count) { i in
                    VStack {
                        Text("Step \(i+1): Selesaikan \(getOperatorPronounce(operation:question.solution[i].operationStep))")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                        Text(question.solution[i].operationStep)
                            .font(.system(size: 48, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top, 1)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("celestialBlue"))
                    )
                    .padding([.leading, .bottom, .trailing], 12)
                }
                
                
//                VStack {
//                    Text("Step 2: Selesaikan penjumlahan")
//                        .font(.system(size: 16, design: .rounded))
//                        .bold()
//                    Text("1 + 18 - 1")
//                        .font(.system(size: 48, design: .rounded))
//                        .bold()
//                        .padding(.top, 1)
//                }
//                .padding(.horizontal, 8)
//                .padding(.vertical, 24)
//                .frame(maxWidth: .infinity)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(Color("celestialBlue"))
//                )
//                .padding([.leading, .bottom, .trailing], 12)
//
//                VStack {
//                    Text("Step 3: Selesaikan Pengurangan")
//                        .font(.system(size: 16, design: .rounded))
//                        .bold()
//                    Text("19 - 1")
//                        .font(.system(size: 48, design: .rounded))
//                        .bold()
//                        .padding(.top, 1)
//                }
//                .padding(.horizontal, 8)
//                .padding(.vertical, 24)
//                .frame(maxWidth: .infinity)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(Color("celestialBlue"))
//                )
//                .padding([.leading, .bottom, .trailing], 12)
                
                VStack {
                    Text("Hasil Akhirnya adalah")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                    Text("\(question.correctAnswer)")
                        .font(.system(size: 56, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 63)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("celestialBlue"))
                )
                .padding([.leading, .bottom, .trailing], 12)
                
                Spacer()
                    
            }
            .padding(10)
        
    }
}

//struct WrapUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        WrapUpView()
//    }
//}
