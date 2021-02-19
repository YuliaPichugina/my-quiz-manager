//
//  EditQuestionView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 17/02/2021.
//

import SwiftUI

struct EditQuestionView: View {
    @State var questionModel: QuestionModel
    @State var answerModels: [AnswerModel]
    @State var answer: String = ""
    @State var questionEdited: Bool = false
    
    var body: some View {
        
        if questionEdited {
            Text("Question succesfully edited and saved!")
        }
        else {
            Text("Tap on the text you want to edit")
                .font(.headline)
            
            VStack {
                
                //we show 5 text fields as this is the maximum number of answers per question. If the question has less than 5 answers, we will display empty text fields, so the user can add a new question when editing, if they wish to do so
                TextField("Question", text: $questionModel.name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                TextField("Enter new answer here", text: $answerModels[0].answerText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                TextField("Enter new answer here", text: $answerModels[1].answerText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                TextField("Enter new answer here", text: $answerModels[2].answerText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                TextField("Enter new answer here", text: $answerModels[3].answerText )
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                TextField("Enter new answer here", text: $answerModels[4].answerText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                Button(action: {
                    
                    let questionsDBManager = QuestionsDBManager()
                    questionsDBManager.updateQuestion(idValue: questionModel.id, newText: questionModel.name)
                    
                    let answersDBManager = AnswerDBManager()
                    for answer in answerModels {
                        answersDBManager.updateAnswer(idValue: answer.id, newText: answer.answerText)
                        
                        questionEdited = true
                    }
                }, label: {
                    MainButton(buttonText: "Save", width: 160)
                })
            }.padding()
            .onAppear(perform: {
                let questionModels = QuestionsDBManager().getQuestions().filter ({ $0.id == questionModel.id })
                self.questionModel = questionModels[0]
                self.answerModels = AnswerDBManager().getAnswers().filter ({ $0.questionID == questionModel.id })
            })

        }
    }
}
