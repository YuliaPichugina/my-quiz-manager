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
        
        if questionDeleted {
            Text("Question succesfully deleted!")
        }
        else {
            VStack {
                
                Text(questionModel.name)
                    .font(.headline)
                
                //checking user's permission level
                let permission = usersDBManager.userPermissions(userID: userID)
            
                if permission == UsersPermissionLevel.Edit {
                    
                    List (formatAnswerView()) {
                        answer in
                        Text(answer.answerText)
                    }
                    Spacer()
                        
                        NavigationLink(destination: EditQuestionView(questionModel: questionModel, answerModels: AnswerDBManager().getAnswers().filter ({ $0.questionID == questionModel.id }))) {
                            MainButton(buttonText: "Edit Question and Answers", width: 300)
                        }
                        
                        Button(action: {
                            //Deleted question and all the answers associated with this question
                            QuestionsDBManager().deleteQuestion(idValue: questionModel.id)
                            AnswerDBManager().deleteAllAnswersForQuestion(questionID: questionModel.id)
                            self.questionDeleted = true
                        }, label: {
                            MainButton(buttonText: "Delete Question and Answers", width: 300)
                        })
                    }
                
                else {
                    List (answerModels) {
                        answer in
                        Text(answer.answerText)
                    }
                    Spacer()
                }
            }
            .onAppear(perform: {
                let questionModels = QuestionsDBManager().getQuestions().filter ({ $0.id == questionModel.id })
                self.questionModel = questionModels[0]
                self.answerModels = AnswerDBManager().getAnswersWithValues().filter ({ $0.questionID == questionModel.id })
            })
        }
    }
    
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

