//
//  AddQuizView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import SwiftUI


struct AddQuizView: View {
    
    @State var quizName: String = ""
    @State var quizID: Int64 = 0
    @State var quizNameSaved: Bool = false
    @State var quizAdded: Bool = false
    @Binding var quizModels: [QuizModel]
    @Binding var questionModels: [QuestionModel]
    
    var body: some View {
        
        //the first step is to save the quiz in database so on this screen we will just proceed with adding the quiz name
        if !quizNameSaved {
            
            VStack {
                TextField("Enter your quiz name", text: $quizName)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                
                Button(action: {
                    // call function to add row in sqlite database
                    let dbManager: QuizesDBManager = QuizesDBManager()
                    dbManager.addQuiz(nameValue: quizName)
                    self.quizID = dbManager.getQuizIdWithName(nameValue: quizName)
                    quizNameSaved = true
                    
                    // refresh the quizzes array
                    self.quizModels = dbManager.getQuizes()
                }, label: {
                    MainButton(buttonText: "Save", width: 160)
                })
                .padding(.top, 10)
            }.padding()
        }
        
        else if quizAdded {
            
            Text("\(quizName) succesfully added!")
                .onAppear(perform: {
                    self.questionModels = QuestionsDBManager().getQuestions()
                })
  //when quiz name is added, we display a different view where user can add questions to their quiz
        } else {
            AddQuestionView(quizAdded: $quizAdded, quizID: quizID)
        }
    }
}

