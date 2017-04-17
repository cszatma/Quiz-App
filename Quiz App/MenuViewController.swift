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
    
    var questions: [Question]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let ref = FIRDatabase.database().reference(fromURL: "https://quiz-app-ccea2.firebaseio.com/")
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutUser))
        view.backgroundColor = UIColor.white
        
        //User isn't logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(logoutUser), with: nil, afterDelay: 0)
        }
        
    }
    
    
    func logoutUser() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }

}
