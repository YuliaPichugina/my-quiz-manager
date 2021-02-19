//
//  UserModel.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import Foundation

class UserModel: Identifiable {
    public var id: Int64 = 0
    public var name: String = ""
    public var password: String = ""
    public var userPermission: UsersPermissionLevel = UsersPermissionLevel.Restricted
}
