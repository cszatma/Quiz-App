//
//  LoginViewController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-14.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import CSKitUniversal
import TinyConstraints
import Firebase

class LoginViewController: UIViewController {
    
    //*** Views ***//
    let inputsView: View =  {
        let view = View(autoresizingToConstraints: false)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: CSButton = {
        let button = CSButton(autoresizingToConstraints: false)
        button.setBackgroundImage(#imageLiteral(resourceName: "SignUpButton"), for: .normal)
        button.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField(autoresizingToConstraints: false)
        textField.placeholder = "Name"
        return textField
    }()
    
    let nameSeparator: View = {
        let view = View(autoresizingToConstraints: false)
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 100)
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField(autoresizingToConstraints: false)
        textField.placeholder = "Email"
        return textField
    }()
    
    let emailSeparator: View = {
        let view = View(autoresizingToConstraints: false)
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 100)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField(autoresizingToConstraints: false)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(autoresizingToConstraints: false)
        imageView.image = #imageLiteral(resourceName: "QuizLogo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //*** End Views ***//

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        view.addSubview(inputsView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        
        setupView()
    }
    
    func setupView() {
        //Create inputsView Constraints
        inputsView.center(in: view)
        inputsView.width(to: view, offset: -24)
        inputsView.height(120)
        
        //Create loginRegisterButton Constraints
        loginRegisterButton.centerX(to: view)
        loginRegisterButton.topToBottom(of: inputsView, offset: 12)
        loginRegisterButton.widthWithMultiplier(to: inputsView, multiplier: 1/2)
        loginRegisterButton.height(60)
        //loginRegisterButton.width(to: inputsView)
        //loginRegisterButton.height(30)
        
        //Create logoImageView Constraints
        logoImageView.centerX(to: view)
        logoImageView.bottomToTop(of: inputsView, offset: -12)
        logoImageView.width(150)
        logoImageView.height(150)
        
        setupInputsView()
    }
    
    func setupInputsView() {
        //Create nameTextField Constraints
        inputsView.addSubview(nameTextField)
        nameTextField.left(to: inputsView, offset: 12)
        nameTextField.top(to: inputsView)
        nameTextField.width(to: inputsView)
        nameTextField.heightWithMultiplier(to: inputsView, multiplier: 1/3)
        
        //Add nameSeparator
        inputsView.addSubview(nameSeparator)
        nameSeparator.left(to: inputsView)
        nameSeparator.topToBottom(of: nameTextField)
        nameSeparator.width(to: inputsView)
        nameSeparator.height(1)
        
        //Create emailTextField Constraints
        inputsView.addSubview(emailTextField)
        emailTextField.left(to: inputsView, offset: 12)
        emailTextField.topToBottom(of: nameSeparator)
        emailTextField.width(to: inputsView)
        emailTextField.height(to: nameTextField)
        
        //Add emailSeparator
        inputsView.addSubview(emailSeparator)
        emailSeparator.left(to: inputsView)
        emailSeparator.topToBottom(of: emailTextField)
        emailSeparator.width(to: inputsView)
        emailSeparator.height(1)
        
        //Create passwordTextField Constraints
        inputsView.addSubview(passwordTextField)
        passwordTextField.left(to: inputsView, offset: 12)
        passwordTextField.topToBottom(of: emailSeparator)
        passwordTextField.width(to: inputsView)
        passwordTextField.height(to: nameTextField)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        guard name != "" || email != "" || password != "" else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { authUser, error in
            if error.hasValue {
                self.displayErrorMessage(errorTitle: "Error", errorMessage: error!.localizedDescription, buttonTitle: "Ok")
                return
            }
            
            guard let id = authUser?.uid else {
                return
            }
            
            let reference = FIRDatabase.database().reference(withPath: "users")
            let user = User(name: name, email: email, score: 0, questionsAnswered: 0)
            let userRef = reference.child(id)
            userRef.setValue(user.toJSON(), withCompletionBlock: { err, ref in
                if err.hasValue {
                    print(err!)
                    return
                }
                
                print("Saved user to database")
            })
        })
    }
    
}
