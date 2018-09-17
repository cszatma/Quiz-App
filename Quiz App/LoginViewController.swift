//
//  LoginViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-14.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Firebase
import HotCocoa
import TinyConstraints

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //*** Views ***//
    let inputsView: CSTextFieldContainerView = {
        let view = CSTextFieldContainerView(numberOfTextFields: 3, withPlaceholders: ["Name", "Email", "Password"])
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.toggleTextFieldVisibility(index: 0, isHidden: true)
        return view
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Your Password?", for: .normal)
        button.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPasswordButtonTouch), for: .touchUpInside)
        return button
    }()
    
    let loginRegisterButton = QAButton(image: #imageLiteral(resourceName: "SignInButton"), target: #selector(handleLoginRegisterButtonTouch))
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "QuizLogo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return segmentedControl
    }()
    //*** End Views ***//
    
    var inputsViewHeight: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        //Setup all the views and constraints
        setupView()
        
        inputsView.textFields[2].isSecureTextEntry = true
        //Set delegates for each textfield.
        for textField in inputsView.textFields {
            textField.delegate = self
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        loginRegisterSegmentedControl.setTitleTextAttributes([kCTFontAttributeName: inputsView.textFields[0].font!], for: .normal)
    }
    
    ///Sets up all the views.
    func setupView() {
        //Add all subviews
        view.addSubview(inputsView)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(logoImageView)
        
        //Create inputsView Constraints
        inputsView.center(in: view)
        inputsView.width(to: view, offset: -24)
        inputsViewHeight = inputsView.height(view.frameHeight / 6.67)
//      inputsViewHeight = inputsView.height(100)
        
        forgotPasswordButton.centerX(to: view)
        forgotPasswordButton.topToBottom(of: inputsView, offset: 12)
        forgotPasswordButton.width(to: inputsView)
        forgotPasswordButton.height(to: inputsView.textFields[1])
        
        //Create loginRegisterButton Constraints
        loginRegisterButton.centerX(to: view)
        loginRegisterButton.topToBottom(of: forgotPasswordButton, offset: 12)
        loginRegisterButton.width(to: inputsView, multiplier: 1 / 2.5)
//      loginRegisterButton.height(60)
//        loginRegisterButton.height(to: view, multiplier: 0.089955)
        loginRegisterButton.height(to: loginRegisterButton, loginRegisterButton.widthAnchor, multiplier: (40 / 123))
        
//      loginRegisterButton.width(to: inputsView)
//      loginRegisterButton.height(30)
        
        //Create loginRegisterSegmentedControl Constraints
        loginRegisterSegmentedControl.centerX(to: view)
        loginRegisterSegmentedControl.bottomToTop(of: inputsView, offset: -12)
        loginRegisterSegmentedControl.width(to: inputsView)
        loginRegisterSegmentedControl.height(view.frameHeight / 18.52778)
//      loginRegisterSegmentedControl.height(36)
        
        //Create logoImageView Constraints
        logoImageView.centerX(to: view)
        logoImageView.bottomToTop(of: loginRegisterSegmentedControl, offset: -12)
        let side = view.frameHeight / 4.446667
        logoImageView.size(CGSize(width: side, height: side))
//      logoImageView.width(150)
//      logoImageView.height(150)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleLoginRegisterButtonTouch() {
        guard let email = inputsView.textFields[1].text, let password = inputsView.textFields[2].text else {
            return
        }
        
        //Make sure user entered and email and password.
        guard email != "" && password != "" else {
            return
        }
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            logInUser(withEmail: email, password: password)
        } else {
            registerUser(withEmail: email, password: password)
        }
    }
    
    ///Called when the user tries to sign up.
    func registerUser(withEmail: String, password: String) {
        guard let name = inputsView.textFields[0].text else {
            return
        }
        
        //Make sure user entered a name
        guard name != "" else {
            return
        }
        
        //Create user
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { authUser, err in
            if let error = err {
                self.displayAlertController(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Ok", style: .default)])
                return
            }
            
            guard let id = authUser?.uid else {
                return
            }
            
            //Create user object and save it to the database
            let reference = FIRDatabase.database().reference(withPath: "users")
            let user = User(name: name, email: withEmail, score: 0, questionsAnswered: 0, currentQuestionSet: defaultQuestionSet, questions: nil)
            let userRef = reference.child(id)
            userRef.setValue(user.toJSON(), withCompletionBlock: { err, ref in
                if let error = err {
                    print(error)
                    return
                }
                
                //Successfully registered and logged in.
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    ///Called when user tries to sign in.
    func logInUser(withEmail: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { user, err in
            if let error = err {
                self.displayAlertController(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Ok", style: .default)])
                return
            }
            
            //Successfully logged in.
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    ///Executed when the value of the loginRegisterSegmentedControl is changed.
    @objc func handleLoginRegisterChanged() {
        let selected = loginRegisterSegmentedControl.selectedSegmentIndex
        let image = selected == 0 ? #imageLiteral(resourceName: "SignInButton") : #imageLiteral(resourceName: "SignUpButton")
        loginRegisterButton.setBackgroundImage(image, for: .normal)
        
        inputsView.toggleTextFieldVisibility(index: 0, isHidden: selected == 0)
        
        //Adjust inputsView
//      inputsViewHeight?.constant = selected == 0 ? 100 : 150
        inputsViewHeight?.constant = selected == 0 ? view.frameHeight / 6.67 : view.frameHeight / 4.446667
    }
    
    @objc func handleForgotPasswordButtonTouch() {
        
    }
    
    ///Called when the return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputsView.textFields.last {
            textField.resignFirstResponder()
            loginRegisterButton.sendActions(for: .touchUpInside)
        } else {
            let index = inputsView.textFields.index(of: textField)
            inputsView.textFields[index! + 1].becomeFirstResponder()
        }
        return true
    }
}
