//
//  QuestionPage.swift
//  MathO
//
//  Created by Vincent Gunawan on 30/03/23.
//

import SwiftUI
import Foundation

struct AnswerButton: View {
    let generatedNumber: Int
    @Binding var isCircle: [Bool]
    @Binding var isSelected: [Bool]
    var pattern: String = ""
    let index: Int
    let correctAnswer: Int
    @Binding var answerCorrectly: [Bool?]
    let currentPageIndex: Int
    
    @ObservedObject var patternViewModel = PatternViewModel()
    var body: some View {
        Button {
            withAnimation {
                if correctAnswer == generatedNumber {
                    isCircle[index].toggle()
                    isSelected[index].toggle()
                    if(currentPageIndex != -1){
                        if pattern != ""{
                            patternViewModel.addPattern(PatternAnswerModel(pattern: pattern, value: 1.0))
                        }
                        answerCorrectly[currentPageIndex] = true
                    }
                } else {
                    isSelected[index].toggle()
                    if(currentPageIndex != -1){
                        if pattern != ""{
                            patternViewModel.addPattern(PatternAnswerModel(pattern: pattern, value: -1.0))
                        }
                        answerCorrectly[currentPageIndex] = false
                    }
                }
            }
        } label: {
            Text("\(generatedNumber)")
                .font(.system(size: 36, design: .rounded))
                .bold()
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(
                    RoundedRectangle(cornerRadius: isCircle[index] ? .infinity : 24)
                        .fill(isCircle[index] ? Color("americanGreen") : isSelected[index] ? Color("fireOpal") : Color("water"))
                        .scaleEffect(isCircle[index] ? 1.0 : 1.0)
                        .animation(.easeIn(duration: 0.1))
                )
                .foregroundColor(Color.white)
                .aspectRatio(1, contentMode: .fit)
        }
        .disabled(isCircle.contains(where: {
            $0 == true
        }) || isSelected.contains(where: {
            $0 == true
        }))
    }
}

struct AnswerProgressBar: View {
    let answerCorrectly: [Bool?]
    let questionCount: Int
    
    let screenWidth = UIScreen.main.bounds.width
    var barLength : CGFloat = 0
    func getBarColor(index: Int) -> Color {
        if(answerCorrectly[index] == Optional(true)){
            return Color("americanGreen")
        } else if(answerCorrectly[index] == Optional(false)){
            return Color("fireOpal")
        } else {
            return Color("water")
        }
    }
    
    init(answerCorrectly: [Bool?], questionCount: Int) {
        self.answerCorrectly = answerCorrectly
        self.questionCount = questionCount
        
        self.barLength  = screenWidth/CGFloat(questionCount)
    }
    var body: some View{
        HStack(spacing: 0){
            ForEach(0..<questionCount) {i in
                Rectangle()
                    .foregroundColor(getBarColor(index: i))
                    .frame(width: barLength, height: 8)
                    .padding(0)
                //                    var _ = print(i, " : ", getBarColor(index: i))
                
            }
        }
    }
}

struct QuestionPage: View {
    @State var question: [Math]
    @State public var currentPageIndex: Int = 0
    @State public var isCircle: [[Bool]] = Array(repeating: [false, false, false, false], count: 12)
    @State public var isSelected: [[Bool]] = Array(repeating: [false, false, false, false], count: 12)
    @State var showSummaryView: Bool = false
    @State var answerCorrectly: [Bool?] = Array(repeating: nil, count: 12)
    @State var test = ""
    var selectedPatterns: [String] = []
    
    
    init() {
        self.selectedPatterns = MathPattern().GeneratePatternByML()
        var tempQuestion: [Math] = []
        
        for pattern in selectedPatterns {
            let test = Math(selectedPattern: pattern.components(separatedBy: ","))
            
            tempQuestion.append(test)
        }
        self.question = tempQuestion
    }
    
    // for progress bar
    
    
    var body: some View {
        
        VStack{
            AnswerProgressBar(answerCorrectly: answerCorrectly, questionCount: question.count
            )
            VStack {
                Text(question[currentPageIndex].stringQuestion)
                    .padding(.horizontal, 24)
                    .font(.system(size: 500))
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 240)
                    .background(Color("celestialBlue"))
                    .cornerRadius(24)
                    .padding([.top, .leading, .trailing], 24)
                    .foregroundColor(Color.white)
                
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        AnswerButton(generatedNumber: question[currentPageIndex].answerOption.answerOptions[0], isCircle: $isCircle[currentPageIndex], isSelected: $isSelected[currentPageIndex], pattern: selectedPatterns[currentPageIndex], index: 0, correctAnswer: question[currentPageIndex].correctAnswer, answerCorrectly: $answerCorrectly, currentPageIndex: currentPageIndex)
                        
                        AnswerButton(generatedNumber: question[currentPageIndex].answerOption.answerOptions[1], isCircle: $isCircle[currentPageIndex], isSelected: $isSelected[currentPageIndex], pattern: selectedPatterns[currentPageIndex], index: 1, correctAnswer: question[currentPageIndex].correctAnswer, answerCorrectly: $answerCorrectly, currentPageIndex: currentPageIndex)
                    }
                    .padding(.horizontal, 32)
                    
                    HStack(spacing: 16) {
                        AnswerButton(generatedNumber: question[currentPageIndex].answerOption.answerOptions[2], isCircle: $isCircle[currentPageIndex], isSelected: $isSelected[currentPageIndex], pattern: selectedPatterns[currentPageIndex], index: 2, correctAnswer: question[currentPageIndex].correctAnswer, answerCorrectly: $answerCorrectly, currentPageIndex: currentPageIndex)
                        
                        AnswerButton(generatedNumber: question[currentPageIndex].answerOption.answerOptions[3], isCircle: $isCircle[currentPageIndex], isSelected: $isSelected[currentPageIndex], pattern: selectedPatterns[currentPageIndex], index: 3, correctAnswer: question[currentPageIndex].correctAnswer, answerCorrectly: $answerCorrectly, currentPageIndex: currentPageIndex)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.top, 32)
                Spacer()
                
                Image("book-illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 42)
                    .offset(y: 35)
                    .onAppear{
                        
                    }
            }
        }
        .navigationBarTitle("Mari Berhitung 🤓")
        .navigationBarItems(trailing: Button(action: {
            if currentPageIndex < question.count-1 {
                currentPageIndex += 1
            } else {
                self.showSummaryView.toggle()
            }
        }, label: {
            if currentPageIndex < question.count-1 {
                Text("Next")
            } else {
                Text("Finish")
            }
            
            
        })
            .disabled(isSelected[currentPageIndex].allSatisfy({ $0 == false}))
        )
        NavigationLink(
            destination: TestView(question: question, isCircle: isCircle, isSelected: isSelected, answerCorrectly: $answerCorrectly),
            isActive: $showSummaryView
        ) {
            EmptyView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
    
}

struct QuestionPage_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPage()
    }
}
