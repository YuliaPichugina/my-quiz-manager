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
     
    // constructor of this class
    init () {
         
        // exception handling
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
             
            // check if the quizes's table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
 
                // if not, then create the table
                try db.run(quizes.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                })
                 
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
             
        } catch {
            // show error message if any
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
    
    public func getQuizes() -> [QuizModel] {
         
        // create empty array
        var quizModels: [QuizModel] = []
     
        // get all users in descending order
        quizes = quizes.order(id.desc)
     
        // exception handling
        do {
     
            // loop through all users
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
