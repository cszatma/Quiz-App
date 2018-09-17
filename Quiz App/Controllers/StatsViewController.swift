//
//  StatsViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-25.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, QAController {
    
    //*** Views ***//
    let correctAnswersLabel: UILabel = {
        let label = UILabel()
        label.text = "Correct Answers: "
        label.backgroundColor = UIColor(hex: 0xD8D8D8)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let questionsAnsweredLabel: UILabel = {
        let label = UILabel()
        label.text = "Questions Answered: "
        label.backgroundColor = UIColor(hex: 0xD8D8D8)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    //*** End Views ***//
    
    var user: User!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Stats"
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(correctAnswersLabel)
        view.addSubview(questionsAnsweredLabel)
        correctAnswersLabel.text?.append(String(user.score))
        questionsAnsweredLabel.text?.append(String(user.questionsAnswered))
        
        correctAnswersLabel.centerX(to: view)
        correctAnswersLabel.top(to: view, offset: view.frameHeight / 3)
        correctAnswersLabel.width(to: view, multiplier: 1/2)
        correctAnswersLabel.height(to: view, multiplier: 1/7)
        
        questionsAnsweredLabel.centerX(to: view)
        questionsAnsweredLabel.topToBottom(of: correctAnswersLabel, offset: correctAnswersLabel.frameHeight)
        questionsAnsweredLabel.width(to: correctAnswersLabel)
        questionsAnsweredLabel.height(to: correctAnswersLabel)
    }
    
}
