//
//  User.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-16.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Firebase

struct User: CustomStringConvertible {
    let name: String
    let email: String
    var score: Int
    var questionsAnswered: Int
    let ref: FIRDatabaseReference?
    let uid: String?
    var currentQuestionSet: [String]
    var questions: Questions?
    
    init(name: String, email: String, score: Int, questionsAnswered: Int, currentQuestionSet: [String], questions: Questions?) {
        self.name = name
        self.email = email
        self.score = score
        self.questionsAnswered = questionsAnswered
        self.currentQuestionSet = currentQuestionSet
        self.questions = questions
        self.ref = nil
        self.uid = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        name = values["name"] as! String
        email = values["email"] as! String
        score = values["score"] as! Int
        questionsAnswered = values["questionsAnswered"] as! Int
        currentQuestionSet = values["currentQuestionSet"].hasValue ? values["currentQuestionSet"] as! [String] : []
        questions = nil
        ref = snapshot.ref
        uid = snapshot.key
    }
    
    func toJSON() -> Any {
        return ["name": name, "email": email, "score": score, "questionsAnswered": questionsAnswered, "currentQuestionSet": currentQuestionSet]
    }
    
    mutating func incrementStats(shouldIncrementScore: Bool) {
        if shouldIncrementScore {
            score += 1
        }
        questionsAnswered += 1
        questions?.removeFirst()
        currentQuestionSet.removeFirst()
        ref?.setValue(toJSON())
        if questions?.count == 0 {
            questions = nil
        }
    }
    
    var description: String {
        return "User: {\(name), \(email), \(score), \(questionsAnswered), \(currentQuestionSet)}"
    }
    
    mutating func generateQuestions(from json: QuestionJSON) {
        var userQuestions = Questions()
        if currentQuestionSet.isEmpty {
            currentQuestionSet = defaultQuestionSet
        }
        for i in 1...10 {
            if currentQuestionSet.contains("question \(i)") {
                userQuestions.append(Question(json: json["question \(i)"] as! QuestionJSON))
            }
        }
        self.questions = userQuestions
    }
    
    var description: String {
        return "User: {\(name), \(email), \(score), \(questionsAnswered)}"
    }
}

let usersRef = FIRDatabase.database().reference().child("users")
