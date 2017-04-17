//
//  ViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

//Special Version of CSKit that runs on iPhone and Simulator (built for both architectures)
import CSKitUniversal
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var questionButton: CSButton!
    @IBOutlet weak var statsButton: CSButton!
    @IBOutlet weak var settingsButton: CSButton!
    
    var questions: [Question]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let ref = FIRDatabase.database().reference(fromURL: "https://quiz-app-ccea2.firebaseio.com/")
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutUser))
        view.backgroundColor = UIColor.white
        //setUpButtons()
    }
    
    func setUpButtons() {
        let buttons = [questionButton, statsButton, settingsButton]
        for button in buttons {
            button?.cornerRadius = 7
            button?.borderWidth = 2
            button?.borderColor = UIColor.black
        }
    }
    
    func logoutUser() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
//        let identifier = "showLogin"
//        performSegue(withIdentifier: identifier, sender: nil)
    }

}
