//
//  QuestionsDBManager.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 16/02/2021.
//

import Foundation
import SQLite
 
class QuestionsDBManager {
     
    // sqlite instance
    private var db: Connection!
     
    // table instance
    private var questions: Table!
 
    // columns instances of table
    private var id: Expression<Int64>!
    private var name: Expression<String>!
    public var quizId: Expression<Int64>!
     
    init () {
        do {
             
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
 
            // creating database connection
            db = try Connection("\(path)/my_questions.sqlite3")
             
            // creating table object
            questions = Table("questions")
            
            // create instances of each column
            id = Expression<Int64>("id")
            name = Expression<String>("name")
            quizId = Expression<Int64>("quizId")
             
           if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
 
                // if not, then create the table
                try db.run(questions.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(quizId)
                })
                 
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
             
        } catch {
            print(error.localizedDescription)
        }
         
    }
    
    public func addQuestion(questionName: String, quizID: Int64) {
        do {
            try db.run(questions.insert(name <- questionName, quizId <- quizID))
            print("added name \(String(describing: name))")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getQuestions() -> [QuestionModel] {
         
        // create empty array
        var questionModels: [QuestionModel] = []
     
        // exception handling
        do {
     
            // loop through all users
            for question in try db.prepare(questions) {
     
                // create new model in each loop iteration
                let questionModel: QuestionModel = QuestionModel()
     
                // set values in model from database
                questionModel.id = question[id]
                questionModel.name = question[name]
                questionModel.quizId = question[quizId]

                // append in new array
                questionModels.append(questionModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return questionModels
    }
    
    public func updateQuestion(idValue: Int64, newText: String) {
        
        let question: Table = questions.filter(id == idValue)
        do {
            if try db.run(question.update(name <- newText)) > 0 {
                print("updated")
            } else {
                print("question not found")
            }
        } catch {
            print("update failed: \(error)")
        }
    }
    
    public func deleteQuestion(idValue: Int64) {
        
        do {
            let quiz: Table = questions.filter(id == idValue)
            try db.run(quiz.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteAllQuestionsForQuiz(quizID: Int64) {
        
        do {
            let answer: Table = questions.filter(quizId == quizID)
            try db.run(answer.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getQuestionIdWithName(nameValue: String) -> Int64 {
        
        let questions = getQuestions()
        
        let filtered = questions.filter({ $0.name == nameValue })
        
        return filtered[0].id
    }
}

