//
//  ViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-07.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import CSKit
import TinyConstraints
import Firebase

typealias FIRObserverHandle = UInt

class MenuViewController: UIViewController {
    
    //*** Views ***//
    let questionsButton = QAButton(image: #imageLiteral(resourceName: "QuestionButton"), target: #selector(handleButtonTouch(_:)))
    let statsButton = QAButton(image: #imageLiteral(resourceName: "StatsButton"), target: #selector(handleButtonTouch(_:)))
    let settingsButton = QAButton(image: #imageLiteral(resourceName: "SettingsButton"), target: #selector(handleButtonTouch(_:)))
    //*** End Views ***//
    
    ///User currently logged in.
    var user: User?
    ///Handle of FIRDatabase observer.
    private var userObserver: FIRObserverHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.title = "Menu"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutUser))
        view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        view.addSubview(questionsButton)
        view.addSubview(statsButton)
        view.addSubview(settingsButton)
        
        statsButton.center(in: view)
        statsButton.width(to: view, multiplier: 1/2)
        statsButton.height(to: statsButton, statsButton.widthAnchor, multiplier: (40/149)) //40/139
        //statsButton.height(to: view, multiplier: 0.089955)
        
        questionsButton.centerX(to: view)
        questionsButton.bottomToTop(of: statsButton, offset: -view.height/7)
        //questionsButton.top(to: view, offset: navigationController!.navigationBar.height + 50)
        questionsButton.width(to: statsButton)
        questionsButton.height(to: statsButton, multiplier: 1)
        
        settingsButton.centerX(to: view)
        settingsButton.topToBottom(of: statsButton, offset: view.height/7)
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
            userObserver = usersRef.child(uid!).observe(.value, with: { userSnapshot in
                self.user = User(snapshot: userSnapshot)
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
            FIRDatabase.database().reference().child("users").child(user!.uid!).removeObserver(withHandle: userObserver!)
        }
        navigationItem.title = ""
        user = nil
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }
    
    
    func handleButtonTouch(_ sender: QAButton) {
        if sender == questionsButton {
            let viewController = QuestionViewController()
            viewController.user = user
            navigationController?.pushViewController(viewController, animated: true)
        } else if sender == statsButton {
            
        } else {
            
        }
    }

}
