//
//  ViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

//Special Version of CSKit that runs on iPhone and Simulator (built for both architectures)
import CSKitUniversal
import TinyConstraints
import Firebase

class MenuViewController: UIViewController {
    
    //*** Views ***//
    let questionsButton = QAButton(image: #imageLiteral(resourceName: "QuestionButton"), target: #selector(handleButtonTouch(_:)))
    let statsButton = QAButton(image: #imageLiteral(resourceName: "StatsButton"), target: #selector(handleButtonTouch(_:)))
    let settingsButton = QAButton(image: #imageLiteral(resourceName: "SettingsButton"), target: #selector(handleButtonTouch(_:)))
    //*** End Views ***//
    
    ///User currently logged in.
    var user: User?
    ///Handle of FIRDatabase observer.
    private var observer: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutUser))
        view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        view.addSubview(questionsButton)
        view.addSubview(statsButton)
        view.addSubview(settingsButton)
        
        statsButton.center(in: view)
        statsButton.widthWithMultiplier(to: view, multiplier: 1/2)
        statsButton.heightWithMultiplier(to: view, multiplier: 0.089955)
        
        questionsButton.centerX(to: view)
        questionsButton.bottomToTop(of: statsButton, offset: -view.height/5)
        questionsButton.width(to: statsButton)
        questionsButton.height(to: statsButton)
        
        settingsButton.centerX(to: view)
        settingsButton.topToBottom(of: statsButton, offset: view.height/5)
        settingsButton.width(to: statsButton)
        settingsButton.height(to: statsButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
    }
    
    func checkIfLoggedIn() {
        //User isn't logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(logoutUser), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            //Get current user
            observer = usersRef.child(uid!).observe(.value, with: { snapshot in
                self.user = User(snapshot: snapshot)
                self.navigationItem.title = self.user?.name
            })
        }
    }
    
    func logoutUser() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        //Remove observer so it no longer tries to listen when a user signs out.
        if user.hasValue {
            FIRDatabase.database().reference().child("users").child(user!.uid!).removeObserver(withHandle: observer!)
        }
        navigationItem.title = ""
        user = nil
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }
    
    
    func handleButtonTouch(_ sender: QAButton) {
        if sender == questionsButton {
            
        } else if sender == statsButton {
            
        } else {
            
        }
    }

}
