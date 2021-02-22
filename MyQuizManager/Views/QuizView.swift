//
//  QuizView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import SwiftUI

struct QuizView: View {
    
    var quiz: QuizModel
    @State var questionModels: [QuestionModel]
    @State var answerModels: [AnswerModel]
    @State var quizAdded: Bool = false
    @State var quizDeleted: Bool = false
    
    @Binding var quizModels: [QuizModel]
    @Binding var userID: Int64
    
    let dbManager = UsersDBManager()
    
    var body: some View {
        
        //feedabck if the user deleted the quiz
        if quizDeleted {
            Text("\(quiz.name) succesfully deleted!")
        }
        
        else {
            VStack {
               
                //checking user's permission level
                let permission = dbManager.userPermissions(userID: userID)
                
                Text(quiz.name)
                    .font(.title)
                
                //users with Restricted permissions cannot see the answers so we will not show them the instruction to tap a question
                if permission != UsersPermissionLevel.Restricted {
                
                Text("(Tap on question to see the answers)")
                    .font(.subheadline)
                }
                
                //adding indices to the questionModels array so we can have a list of numbered questions
                let withIndex = questionModels.enumerated().map({ $0 })
                
                List (withIndex, id: \.element.name) { index, model in
                    
                    //if user has Restricted permission, they can only see the list of questions and can't open each question to see the answers
                    if permission == UsersPermissionLevel.Restricted {
                        Text("\(index + 1). \(model.name)")
                    }
                    //if user has View or edit permissions, they can open a separate view for each questions and see the answers
                    else {
                        NavigationLink("\(index + 1). \(model.name)", destination: QuestionView(quiz: quiz, questionModel: model, answerModels: answerModels, userID: $userID))
                    }
                }
                .padding()
                Spacer()
                
                //we only show buttons to add question an delete quiz to users with Edit permissions
                if permission == UsersPermissionLevel.Edit {
                    HStack {
                        NavigationLink(destination: AddQuestionView(quizAdded: $quizAdded, quizID: quiz.id)) {
                            MainButton(buttonText: "Add Question", width: 160)
                        }
                        Button(action: {
                            
                            deleteAllQuizdata()
                            
                            // refresh the quiz models array
                            self.quizModels = QuizesDBManager().getQuizes()
                            self.quizDeleted = true
                        }, label: {
                            MainButton(buttonText: "Delete quiz", width: 160)
                        })
                    }
                }
            }
            //update the list of questions every time this view is shown
            .onAppear(perform: {
                self.questionModels = QuestionsDBManager().getQuestions().filter ({ $0.quizId == quiz.id })
            })
        }
    }
    
    func deleteAllQuizdata() {
        QuizesDBManager().deleteQuiz(idValue: quiz.id)
        QuestionsDBManager().deleteAllQuestionsForQuiz(quizID: quiz.id)
        
        for model in questionModels {
            AnswerDBManager().deleteAllAnswersForQuestion(questionID: model.id)
        }
    }
}


