//
//  ViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

//Special Version of CSKit that runs on iPhone and Simulator (built for both architectures)
import CSKitUniversal

class ViewController: UIViewController {
    
    @IBOutlet var viewQuestionButton: UIButton!
    
    var questions: [Question]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestionsFromServer() { loadedQuestions in
            self.questions = loadedQuestions
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        guard let
    }

}

