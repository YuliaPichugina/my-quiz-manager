//
//  AddQuestionView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 16/02/2021.
//

import SwiftUI

struct AddQuestionView: View {
    
    // create variables to store user input values
    @State var question: String = ""
    @State var answerA: String = ""
    @State var answerB: String = ""
    @State var answerC: String = ""
    @State var answerD: String = ""
    @State var answerE: String = ""
    @State var questionAdded: Bool = false
    
    @Binding var quizAdded: Bool
    var quizID: Int64
    
    var body: some View {
        
        if questionAdded {
            Text("Question succesfully added!")
        }
        else {
            VStack {
                TextField("Question", text: $question)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
        //we display 5 text firled for answers which if the maximum number of answers per question, accoring to teh business requirements. User may leave some fields blank if they want to add less than 5 questions
                TextField("A. Answer", text: $answerA)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                TextField("B. Answer", text: $answerB)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                TextField("C. Answer", text: $answerC)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                TextField("D. Answer", text: $answerD)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                TextField("E. Answer", text: $answerE)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                VStack {
                    Button(action: {
                        //if user wants to add another question, we refresh the view and show empty text fields
                        let dbManager: QuestionsDBManager = QuestionsDBManager()
                        dbManager.addQuestion(questionName: question, quizID: quizID)
                        addAnswers()
                        self.question = ""
                        self.answerA = ""
                        self.answerB = ""
                        self.answerC = ""
                        self.answerD = ""
                        self.answerE = ""
                    }, label: {
                        MainButton(buttonText: "Add another question", width: 220)
                    })
                    
                    Button(action: {
                        let dbManager: QuestionsDBManager = QuestionsDBManager()
                        dbManager.addQuestion(questionName: question, quizID: quizID)
                        addAnswers()
                        self.quizAdded = true
                        self.questionAdded = true
                    }, label: {
                        MainButton(buttonText: "Save and finish the quiz", width: 220)
                    })
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
    }
    
    //saving answers to the database
    func addAnswers() {
        
        let questionsDBManager: QuestionsDBManager = QuestionsDBManager()
        let questionID = questionsDBManager.getQuestionIdWithName(nameValue: question)
        
        let answersDBManager: AnswerDBManager = AnswerDBManager()
        
        answersDBManager.addAnswer(answer: self.answerA, questionID: questionID)
        answersDBManager.addAnswer(answer: self.answerB, questionID: questionID)
        answersDBManager.addAnswer(answer: self.answerC, questionID: questionID)
        answersDBManager.addAnswer(answer: self.answerD, questionID: questionID)
        answersDBManager.addAnswer(answer: self.answerE, questionID: questionID)
    }
}
