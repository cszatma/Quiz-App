//
//  Question.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Firebase

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
    
    var description: String {
        return "{Question: \(question), Answer: \(answer), Choices: \(choices)}"
    }
    
}

let questionsRef = FIRDatabase.database().reference().child("question-objects")
