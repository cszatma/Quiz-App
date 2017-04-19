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
    ///User currently logged in.
    var user: User?
    ///Handle of FIRDatabase observer.
    private var observer: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutUser))
        view.backgroundColor = UIColor.white
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
            observer = FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { snapshot in
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

}
