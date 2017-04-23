//
//  Question.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Firebase

typealias Questions = [Question]
typealias QuestionJSON = [String: Any]

struct Question: CustomStringConvertible {
    
    let question: String
    let answer: String
    let choices: [String]
    let ref: FIRDatabaseReference?
    let key: String
    
    init(question: String, answer: String, choices: [String], key: String = "") {
        self.question = question
        self.answer = answer
        self.choices = choices
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        self.question = snapshotValue["question"] as! String
        self.answer = snapshotValue["answer"] as! String
        self.choices = snapshotValue["choices"] as! [String]
        ref = snapshot.ref
    }
    
    init(json: QuestionJSON) {
        self.init(question: json["question"] as! String, answer: json["answer"] as! String, choices: json["choices"] as! [String])
    }
    
    var description: String {
        return "{Question: \(question), Answer: \(answer), Choices: \(choices)}"
    }
    
}

let questionsRef = FIRDatabase.database().reference().child("question-objects")
let defaultQuestionSet = ["question 1", "question 2", "question 3", "question 4", "question 5", "question 6", "question 7", "question 8", "question 9", "question 10"]
