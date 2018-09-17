//
//  QuestionViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-20.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import TinyConstraints
import HotCocoa

class QuestionViewController: UIViewController, QAController {
    
    //*** Views ***//
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Question"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let choiceButtons = [UIButton(), UIButton(), UIButton(), UIButton()]
    //*** End Views ***//
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xD8D8D8)
        setupView()
        loadQuestionSet()
    }
    
    ///Sets up all the views, adding the necessary constraints.
    func setupView() {
        view.addSubview(questionLabel)
        questionLabel.centerX(to: view)
        questionLabel.top(to: view, offset: 75)
        questionLabel.width(to: view, offset: -20) //71/75
        questionLabel.height(to: view, multiplier: (165 / 667))
        setupButtons()
    }
    
    ///Sets up the choice buttons.
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
                choiceButtons[i].topToBottom(of: choiceButtons[i-1], offset: view.frameHeight * (39 / 667))
            }
            choiceButtons[i].width(to: view, offset: -30)
            choiceButtons[i].height(to: view, multiplier: (70/667))
        }
    }
    
    ///Called when Next Question BarButton is touched. Displays the next question to the user.
    @objc func handleNextQuestionTouched() {
        guard user.questions != nil else { //Load next set if current set is finished.
            loadQuestionSet()
            return
        }
        loadNextQuestion()
    }
    
    ///Called when the user selects a choice. The user will then be alerted whether or not it is the right answer.
    @objc func handleChoiceButtonTouched(_ sender: UIButton) {
        if sender.text == user.questions?[0].answer { //Handle correct answer.
            sender.backgroundColor = UIColor(hex: 0x80FF00)
            user.incrementStats(shouldIncrementScore: true)
        } else { //Handle incorrect answer.
            sender.backgroundColor = .red
            choiceButtons.forEach({
                if $0.text == user.questions?[0].answer {
                    $0.backgroundColor = UIColor(hex: 0x80FF00)
                }
            })
            user.incrementStats(shouldIncrementScore: false)
        }
        choiceButtons.forEach({$0.isEnabled = false})
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next Question", style: .plain, target: self, action: #selector(handleNextQuestionTouched))
    }
    
    ///Loads the next available set of questions from the database.
    func loadQuestionSet() {
        guard user.questions == nil else { //If a set is already loaded just load the next question in the set.
            loadNextQuestion()
            return
        }
        //Fetch new set.
        questionsRef.child("set \((self.user!.questionsAnswered/10) + 1)").observeSingleEvent(of: .value, with: { questionSnapshot in
            guard questionSnapshot.exists() else {
                self.questionLabel.text = "All questions answered!"
                self.choiceButtons.forEach({
                    $0.isEnabled = false
                    $0.setTitle("", for: .normal)
                })
                return
            }
            let values = questionSnapshot.value as! QuestionJSON
            self.user.generateQuestions(from: values)
            self.loadNextQuestion()
        })
    }
    
    ///Gets the next question from the user's questions array and sets up the questionLabel and choiceButtons.
    func loadNextQuestion() {
        navigationItem.rightBarButtonItem = nil
        questionLabel.text = user.questions?[0].question
        for i in 0..<choiceButtons.count {
            choiceButtons[i].setTitle(user.questions?[0].choices[i], for: .normal)
            choiceButtons[i].backgroundColor = UIColor(hex: 0x8C8C8C)
            choiceButtons[i].isEnabled = true
        }
        
    }
    
}
