//
//  AnswerModel.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 17/02/2021.
//

import Foundation

class AnswerModel: Identifiable {
    public var id: Int64 = 0
    public var answerText: String = ""
    public var questionID: Int64 = 0
}
