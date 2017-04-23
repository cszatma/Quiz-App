//
//  QuestionViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-20.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import CSKit
import TinyConstraints

class QuestionViewController: UIViewController {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Question"
        label.backgroundColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let statsButton = QAButton(image: #imageLiteral(resourceName: "StatsButton"), target: #selector(handleBack))
    
    let choiceButtons = [CSButton(), CSButton(), CSButton(), CSButton()]
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view .backgroundColor = UIColor(hex: 0xD8D8D8)
        setupView()
        loadQuestions()
    }
    
    func setupView() {
        view.addSubview(questionLabel)
        questionLabel.centerX(to: view)
        questionLabel.top(to: view, offset: 75)
//        questionLabel.widthWithMultiplier(to: view, multiplier: (71/75))
        questionLabel.width(to: view, offset: -20)
        questionLabel.height(to: view, multiplier: (165/667))
        setupButtons()
    }
    
    func setupButtons() {
        for i in 0..<choiceButtons.count {
            view.addSubview(choiceButtons[i])
            choiceButtons[i].backgroundColor = UIColor(hex: 0x8C8C8C)
            choiceButtons[i].layer.cornerRadius = 5
            choiceButtons[i].layer.masksToBounds = true
            choiceButtons[i].addTarget(self, action: #selector(handleChoiceButtonTouched(_:)), for: .touchUpInside)
            choiceButtons[i].centerX(to: view)
            if i == 0 {
                choiceButtons[i].topToBottom(of: questionLabel, offset: 10)
            } else {
                choiceButtons[i].topToBottom(of: choiceButtons[i-1], offset: view.height*(39/667))
                //choiceButtons[i].topToBottom(of: choiceButtons[i-1])
            }
            choiceButtons[i].width(to: view, offset: -30)
            choiceButtons[i].height(to: view, multiplier: (70/667))
        }
    }
    
    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleChoiceButtonTouched(_ sender: CSButton) {
        if sender == choiceButtons[0] {
            questionsRef.child("set 1").child("question 1").observeSingleEvent(of: .value, with: { snapshot in
                let q = Question(snapshot: snapshot)
                print(q)
            }, withCancel: nil)
        } else if sender == choiceButtons[1] {
            print("Choice 2 selected!")
        } else if sender == choiceButtons[2] {
            print("Choice 3 selected!")
        } else if sender == choiceButtons[3] {
            print("Choice 4 selected!")
        }
        
    }
    
    func loadQuestions() {
            questionsRef.child("set \((self.user!.questionsAnswered/10) + 1)").observeSingleEvent(of: .value, with: { questionSnapshot in
                guard questionSnapshot.exists() else { return }
                let values = questionSnapshot.value as! QuestionJSON
                self.user.generateQuestions(from: values)
        })
    }
    
}
