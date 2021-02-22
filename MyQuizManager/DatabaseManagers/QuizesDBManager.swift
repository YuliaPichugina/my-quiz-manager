//
//  QuizesDBManager.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import Foundation
import SQLite
 
class QuizesDBManager {
     
    // sqlite instance
    private var db: Connection!
     
    // table instance
    private var quizes: Table!
 
    // columns instances of table
    private var id: Expression<Int64>!
    private var name: Expression<String>!
     
    init () {
         
        do {
             
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
 
            // creating database connection
            db = try Connection("\(path)/my_quizes.sqlite3")
             
            // creating table object
            quizes = Table("quizes")
             
            // create instances of each column
            id = Expression<Int64>("id")
            name = Expression<String>("name")
 
                // if not, then create the table
                try db.run(quizes.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                })
             
        } catch {
            print(error.localizedDescription)
        }
         
    }
    
    public func addQuiz(nameValue: String) {
        do {
            try db.run(quizes.insert(name <- nameValue))
            print("added name \(String(describing: name))")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getQuizIdWithName(nameValue: String) -> Int64 {
        
        let quizes = getQuizes()
        
        let filtered = quizes.filter({ $0.name == nameValue })
        
        return filtered[0].id
    }
    
    public func getQuizes() -> [QuizModel] {
         
        // create empty array
        var quizModels: [QuizModel] = []
     
        // get all quizes in descending order so the newest will appear on top
        quizes = quizes.order(id.desc)
     
        do {
            for quiz in try db.prepare(quizes) {
     
                // create new model in each loop iteration
                let quizModel: QuizModel = QuizModel()
     
                // set values in model from database
                quizModel.id = quiz[id]
                quizModel.name = quiz[name]
     
                // append in new array
                quizModels.append(quizModel)
            }
        } catch {
            print(error.localizedDescription)
        }
     
        // return array
        return quizModels
    }
    
    public func deleteQuiz(idValue: Int64) {
        
        do {
            let quiz: Table = quizes.filter(id == idValue)
            try db.run(quiz.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}
