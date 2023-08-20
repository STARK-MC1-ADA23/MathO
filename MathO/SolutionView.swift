//
//  SolutionView.swift
//  Question Screen Math'o
//
//  Created by Petrus Sinaga on 03/04/23.
//

import SwiftUI

struct SolutionView: View {
    @State private var currentStep = 0
    private var question: Math
    let ll: CGFloat
    @State public var currentPageIndex: Int = 0
    @State public var isCircle: [[Bool]] = Array(repeating: [false, false, false, false], count: 12)
    @State public var isSelected: [[Bool]] = Array(repeating: [false, false, false, false], count: 12)
    @State var showSummaryView: Bool = false
    @State var answerCorrectly: [Bool?] = Array(repeating: nil, count: 4)
    @State private var isShowingTriangle: Bool = false
    @State private var isFinishSolution: Bool = false
    
    
    init(question: Math) {
        self.question = question
        self.ll = CGFloat(50 + (5-(question.solution.count+1)) * 30)
    }
    
    var body: some View {
        NavigationView(){
            ScrollView{
                VStack{
                    if(currentStep < question.solution.count){
                        HStack{
                            ForEach(0..<question.solution[currentStep].solvingStep.count, id: \.self) { solvingStepIndex in
                                Text(question.solution[currentStep].solvingStep[solvingStepIndex])
                                    .font(.system(size: 32, design: .rounded))
                                    .bold()
                                    .opacity(solvingStepIndex == 1 ? 1 : 0.5)
                            }
                        }
                    }
                    
                    CustomIndicator(numberOfStep: question.solution.count + 1, lengthLine: CGFloat(ll), currentStep: $currentStep)
                        .padding(24)
                    
                    if(currentStep < question.solution.count){
                        
                        VStack {
                            Text("Kamu perlu menjawab pertanyaan ini")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                            Text(question.solution[currentStep].operationStep)
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
                        .padding([.leading, .bottom, .trailing], 32)
                        
                        if !isShowingTriangle {
                            VStack (spacing: 16) {
                                HStack (spacing: 16) {
                                    AnswerButton(generatedNumber: question.solution[currentStep].answerOptions[0], isCircle: $isCircle[currentStep], isSelected: $isSelected[currentStep], index: 0, correctAnswer: question.solution[currentStep].rightAnswerIndex, answerCorrectly: $answerCorrectly, currentPageIndex: currentStep)
                                    
                                    AnswerButton(generatedNumber: question.solution[currentStep].answerOptions[1], isCircle: $isCircle[currentStep], isSelected: $isSelected[currentStep], index: 1, correctAnswer: question.solution[currentStep].rightAnswerIndex, answerCorrectly: $answerCorrectly, currentPageIndex: currentStep)
                                }
                                .padding(.horizontal, 32)
                                
                                HStack (spacing: 16){
                                    AnswerButton(generatedNumber: question.solution[currentStep].answerOptions[2], isCircle: $isCircle[currentStep], isSelected: $isSelected[currentStep], index: 2, correctAnswer: question.solution[currentStep].rightAnswerIndex, answerCorrectly: $answerCorrectly, currentPageIndex: currentStep)
                                    
                                    AnswerButton(generatedNumber: question.solution[currentStep].answerOptions[3], isCircle: $isCircle[currentStep], isSelected: $isSelected[currentStep], index: 3, correctAnswer: question.solution[currentStep].rightAnswerIndex, answerCorrectly: $answerCorrectly, currentPageIndex: currentStep)
                                }
                                .padding(.horizontal, 32)
                            }
                            .onChange(of: isSelected[currentStep]) { newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    isShowingTriangle = true
                                }
                            }
                        } else {
                            SegitigaAjaibView()
                                .onChange(of: currentStep) { newValue in
                                    isShowingTriangle = false
                                }
                        }
                    } else {
                        WrapUpView(
                            question: question
                        )
                    }
                    
                }.padding(.vertical, 16)
            }
        }.navigationBarBackButtonHidden(true)
    }
}



func segitigaAjaib(operation: String) -> String {
    let ops = operation.components(separatedBy: " ")[1]
    switch ops {
    case "x":
        return "segitiga-ajaib-multi"
    case ":":
        return "segitiga-ajaib-diff"
    case "+":
        return "segitiga-ajaib-plus"
    case "-":
        return "segitiga-ajaib-min"
    default:
        return "segitiga-ajaib-diff"
    }
}



struct SolutionView_Previews: PreviewProvider {
    static var previews: some View {
        SolutionView(question: Math())
    }
}

struct CustomIndicator: View {
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
