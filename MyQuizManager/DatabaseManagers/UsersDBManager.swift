//
//  UsersDBManager.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import Foundation
import SQLite
import CryptoKit

class UsersDBManager {
    
   // sqlite instance
   private var db: Connection!
    
   // table instance
   private var users: Table!

   // columns instances of table
   private var id: Expression<Int64>!
   private var name: Expression<String>!
   private var password: Expression<String>!
   private var permissionLevel: Expression<String>!
    
   init () {
        
       do {
           // path of document directory
           let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""

           // creating database connection
           db = try Connection("\(path)/my_users.sqlite3")
            
           // creating table object
           users = Table("users")
            
           // create instances of each column
           id = Expression<Int64>("id")
           name = Expression<String>("name")
           password = Expression<String>("password")
           permissionLevel = Expression<String>("permissionLevel")
            
       } catch {
           print(error.localizedDescription)
       }
        
   }
   
    //this function is currently not called anywhere but it was used to add users to the database and can be used in the future if we add user registration functionality
    public func addUser(userName: String, userPassword: String, userPermission: UsersPermissionLevel) {
       do {
        try db.run(users.insert(name <- userName, password <- hashedPassword(password:userPassword), permissionLevel <- userPermission.rawValue))
        print("added name \(String(describing: name))")
        print("added name \(String(describing: password))")
       } catch {
           print(error.localizedDescription)
       }
   }
   
   public func getUsers() -> [UserModel] {

       // create empty array
       var userModels: [UserModel] = []
    
       // exception handling
       do {

           // loop through all users
           for user in try db.prepare(users) {

               // create new model in each loop iteration
               let userModel: UserModel = UserModel()

               // set values in model from database
               userModel.id = user[id]
               userModel.name = user[name]
               userModel.password = user[password]
               userModel.userPermission = UsersPermissionLevel(rawValue: user[permissionLevel]) ?? UsersPermissionLevel.Restricted

               // append in new array
               userModels.append(userModel)
           }
       } catch {
           print(error.localizedDescription)
       }

       // return array
       return userModels
  }
    
    public func userProvidedCorrectCredentials(username: String, password: String) -> Bool {
        let users = getUsers()
        
        let hashedPassword = self.hashedPassword(password: password)
        
        for user in users {
            if username == user.name && hashedPassword == user.password {
                return true
            }
        }
        
        return false
    }
    
    //getting userID when needed with the combination of username and password
    public func getUserID(username: String, password: String) -> Int64 {
        let users = getUsers()
        var id = Int64()
        
        let hashedPassword = self.hashedPassword(password: password)
        
        for user in users {
            if username == user.name && hashedPassword == user.password {
                id = user.id
            }
        }
        
        return id
    }
    
    public func userPermissions(userID: Int64) -> UsersPermissionLevel {
        let users = getUsers()
        print(userID)
        
        let filtered = users.filter({ $0.id == userID })
        
        return filtered[0].userPermission
    }
  
    //we don't store user's password in the database for security reasons, so this function is to hash the password and store it safely
    private func hashedPassword(password: String) -> String {
        
        let input = Data(password.utf8)
        let hashed = SHA256.hash(data: input)

        let hashedPassword = hashed.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashedPassword
    }
}
