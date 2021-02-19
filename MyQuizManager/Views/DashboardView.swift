//
//  DashboardView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import SwiftUI

struct DashboardView: View {
    
    @Binding var userLoggedIn: Bool
    @Binding var userID: Int64
    
    @State var quizModels: [QuizModel] = []
    @State var questionModels: [QuestionModel] = []
    @State var answerModels: [AnswerModel] = []
    
    var body: some View {
        
        NavigationView {
            VStack {
                //List of all quizzes from the database
                List (self.quizModels) { (model) in
                    NavigationLink(model.name, destination: QuizView(quiz: model, questionModels: self.questionModels.filter ({ $0.quizId == model.id }), answerModels: answerModels, quizModels: $quizModels, userID: $userID))
                        .onAppear(perform: {
                            self.questionModels = QuestionsDBManager().getQuestions()
                        })
                }
                
                let dbManager: UsersDBManager = UsersDBManager()
                let permission = dbManager.userPermissions(userID: userID)
                
                //only if the user has Edit permission, they can see the button to add a new quiz
                if permission == UsersPermissionLevel.Edit {
                    
                    NavigationLink(destination: AddQuizView(quizModels: $quizModels, questionModels: $questionModels)) {
                        MainButton(buttonText: "Add Quiz", width: 160)
                    }
                }
            }
            .navigationBarTitle("All quizzes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log out") {
                        userLoggedIn = false
                    }
                }
            }
        }
        //every time we open Dashboard, we refresh the list of quizes so teh user has up to date information
        .onAppear(perform: {
            self.quizModels = QuizesDBManager().getQuizes()
        })
    }
}

