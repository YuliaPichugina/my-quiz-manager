//
//  QuestionView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 16/02/2021.
//

import SwiftUI

struct QuestionView: View {
    
    var quiz: QuizModel
    @State var questionModel: QuestionModel
    @State var answerModels: [AnswerModel]
    @State var questionDeleted: Bool = false
    
    @Binding var userID: Int64
    
    let usersDBManager = UsersDBManager()
    
    var body: some View {
        
        //feedback view after the user deleted the question
        if questionDeleted {
            Text("Question succesfully deleted!")
        }
        else {
            VStack {
                
                Text(questionModel.name)
                    .font(.headline)
                
                List (formatAnswerView()) {
                    answer in
                    Text(answer.answerText)
                }
                
                //checking user's permission level
                let permission = usersDBManager.userPermissions(userID: userID)
                
                //only users's with Edit permissions can see the buttons to edit or delete question and answers
                if permission == UsersPermissionLevel.Edit {
                    
                    Spacer()
                    //re-directing to another view if user wants to edit the question
                        NavigationLink(destination: EditQuestionView(questionModel: questionModel, answerModels: AnswerDBManager().getAnswers().filter ({ $0.questionID == questionModel.id }))) {
                            MainButton(buttonText: "Edit Question and Answers", width: 300)
                        }
                        
                        Button(action: {
                            //Delete question and all the answers associated with this question
                            QuestionsDBManager().deleteQuestion(idValue: questionModel.id)
                            AnswerDBManager().deleteAllAnswersForQuestion(questionID: questionModel.id)
                            self.questionDeleted = true
                        }, label: {
                            MainButton(buttonText: "Delete Question and Answers", width: 300)
                        })
                    }
                    Spacer()
            }
            .onAppear(perform: {
                let questionModels = QuestionsDBManager().getQuestions().filter ({ $0.id == questionModel.id })
                self.questionModel = questionModels[0]
                self.answerModels = AnswerDBManager().getAnswersWithValues().filter ({ $0.questionID == questionModel.id })
            })
        }
    }
    
    //formatting answers so they appear with correct uppercase indices 
    func formatAnswerView() -> [FormattedAnswerModel] {
        var indices = ["A", "B", "C", "D", "E"]
        var answers: [String] = []
        
        var formattedAnswers: [FormattedAnswerModel] = []
        
        while indices.count > answerModels.count {
            indices.removeLast()
        }
        
        for answer in answerModels {
            answers.append(answer.answerText)
        }
        
        let fullAnswersStrings = zip(indices, answers).map { "\($0). \($1)" }
        
        for answer in fullAnswersStrings {

            let formattedModel = FormattedAnswerModel()
            formattedModel.answerText = answer
            formattedAnswers.append(formattedModel)
        }
        
        return formattedAnswers
    }
}

