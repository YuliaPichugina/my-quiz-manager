//
//  AnswerDBManager.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 17/02/2021.
//

import Foundation
import SQLite
 
class AnswerDBManager {
     
    // sqlite instance
    private var db: Connection!
     
    // table instance
    private var answers: Table!
 
    // columns instances of table
    private var id: Expression<Int64>!
    private var answerText: Expression<String>!
    public var questionId: Expression<Int64>!
     
    init () {
        do {
             
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
 
            // creating database connection
            db = try Connection("\(path)/my_answers.sqlite3")
             
            // creating table object
            answers = Table("answers")
            
            // create instances of each column
            id = Expression<Int64>("id")
            answerText = Expression<String>("answerText")
            questionId = Expression<Int64>("questionId")
 
                // if not, then create the table
                try db.run(answers.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(answerText)
                    t.column(questionId)
                })
             
        } catch {
            print(error.localizedDescription)
        }
         
    }
    
    public func addAnswer(answer: String, questionID: Int64) {
        do {
            try db.run(answers.insert(answerText <- answer, questionId <- questionID))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getAnswers() -> [AnswerModel] {
         
        // create empty array
        var answerModels: [AnswerModel] = []
     
        // exception handling
        do {
     
            // loop through all users
            for answer in try db.prepare(answers) {
     
                // create new model in each loop iteration
                let answerModel: AnswerModel = AnswerModel()
     
                // set values in model from database
                answerModel.id = answer[id]
                answerModel.answerText = answer[answerText]
                answerModel.questionID = answer[questionId]

                // append in new array
                answerModels.append(answerModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        return answerModels
    }
    
    public func getAnswersWithValues()  -> [AnswerModel] {
        let answers = getAnswers().filter ({ $0.answerText != "" })
        return answers
    }
    
    public func deleteAnswer(idValue: Int64) {
        
        do {
            let answer: Table = answers.filter(id == idValue)
            try db.run(answer.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteAllAnswersForQuestion(questionID: Int64) {
        
        do {
            let answer: Table = answers.filter(questionId == questionID)
            try db.run(answer.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func updateAnswer(idValue: Int64, newText: String) {
        
        let answer: Table = answers.filter(id == idValue)
        do {
            if try db.run(answer.update(answerText <- newText)) > 0 {
                print("updated")
            } else {
                print("answer not found")
            }
        } catch {
            print("update failed: \(error)")
        }
    }
}
