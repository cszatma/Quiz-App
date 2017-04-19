//
//  User.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-16.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Firebase

struct User {
    let name: String
    let email: String
    let score: Int
    let questionsAnswered: Int
    let ref: FIRDatabaseReference?
    let uid: String?
    
    init(name: String, email: String, score: Int, questionsAnswered: Int) {
        self.name = name
        self.email = email
        self.score = score
        self.questionsAnswered = questionsAnswered
        self.ref = nil
        self.uid = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        name = values["name"] as! String
        email = values["email"] as! String
        score = values["score"] as! Int
        questionsAnswered = values["questionsAnswered"] as! Int
        ref = snapshot.ref
        uid = snapshot.key
    }
    
    func toJSON() -> Any {
        return ["name": name, "email": email, "score": score, "questionsAnswered": questionsAnswered]
    }
    
    var description: String {
        return "User: {\(name), \(email), \(score), \(questionsAnswered)}"
    }
}
