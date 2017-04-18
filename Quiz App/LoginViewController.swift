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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
        button.addTarget(self, action: #selector(handleLoginRegisterButtonPress), for: .touchUpInside)
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
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    //*** End Views ***//
    
    var inputsViewHeight: Constraint?
    var nameTextFieldHeight: Constraint?
    var emailTextFieldHeight: Constraint?
    var passwordTextFieldHeight: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        view.addSubview(inputsView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(logoImageView)
        
        setupView()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    ///Sets up all the views.
    func setupView() {
        //Create inputsView Constraints
        inputsView.center(in: view)
        inputsView.width(to: view, offset: -24)
        inputsViewHeight = inputsView.height(150)
        
        //Create loginRegisterButton Constraints
        loginRegisterButton.centerX(to: view)
        loginRegisterButton.topToBottom(of: inputsView, offset: 12)
        loginRegisterButton.widthWithMultiplier(to: inputsView, multiplier: 1/2)
        loginRegisterButton.height(60)
        //loginRegisterButton.width(to: inputsView)
        //loginRegisterButton.height(30)
        
        //Create loginRegisterSegmentedControl Constraints
        loginRegisterSegmentedControl.centerX(to: view)
        loginRegisterSegmentedControl.bottomToTop(of: inputsView, offset: -12)
        loginRegisterSegmentedControl.width(to: inputsView)
        loginRegisterSegmentedControl.height(36)
        
        //Create logoImageView Constraints
        logoImageView.centerX(to: view)
        logoImageView.bottomToTop(of: loginRegisterSegmentedControl, offset: -12)
        logoImageView.width(150)
        logoImageView.height(150)
        
        setupInputsView()
        
        
    }
    
    ///Sets up all the textfields inside the inputsView.
    func setupInputsView() {
        //Create nameTextField Constraints
        inputsView.addSubview(nameTextField)
        nameTextField.left(to: inputsView, offset: 12)
        nameTextField.top(to: inputsView)
        nameTextField.width(to: inputsView)
        nameTextFieldHeight = nameTextField.heightWithMultiplier(to: inputsView, multiplier: 1/3)
        
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
        emailTextFieldHeight = emailTextField.heightWithMultiplier(to: inputsView, multiplier: 1/3)
        
        //Add emailSeparator
        inputsView.addSubview(emailSeparator)
        emailSeparator.left(to: inputsView)
        emailSeparator.topToBottom(of: emailTextField)
        emailSeparator.width(to: inputsView)
        emailSeparator.height(1)
        
        //Create passwordTextField Constraints
        inputsView.addSubview(passwordTextField)
        passwordTextField.left(to: inputsView, offset: 12)
        //passwordTextField.topToBottom(of: emailSeparator)
        passwordTextField.bottom(to: inputsView)
        passwordTextField.width(to: inputsView)
        passwordTextFieldHeight = passwordTextField.heightWithMultiplier(to: inputsView, multiplier: 1/3)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleLoginRegisterButtonPress() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
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
    
    ///Executed when the loginRegisterButton is pressed.
    func registerUser(withEmail: String, password: String) {
        guard let name = nameTextField.text else {
            return
        }
        
        //Make sure user entered a name
        guard name != "" else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { authUser, error in
            if error.hasValue {
                self.displayErrorMessage(errorTitle: "Error", errorMessage: error!.localizedDescription, buttonTitle: "Ok")
                return
            }
            
            guard let id = authUser?.uid else {
                return
            }
            
            let reference = FIRDatabase.database().reference(withPath: "users")
            let user = User(name: name, email: withEmail, score: 0, questionsAnswered: 0)
            let userRef = reference.child(id)
            userRef.setValue(user.toJSON(), withCompletionBlock: { err, ref in
                if err.hasValue {
                    print(err!)
                    return
                }
                
                //Successfully registered and logged in.
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func logInUser(withEmail: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { user, error in
            if error.hasValue {
                self.displayErrorMessage(errorTitle: "Error", errorMessage: error!.localizedDescription, buttonTitle: "Ok")
                return
            }
            
            //Successfully logged in.
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    ///Executed when the value of the loginRegisterSegmentedControl is changed.
    func handleLoginRegisterChanged() {
        let selected = loginRegisterSegmentedControl.selectedSegmentIndex
        let image = selected == 0 ? #imageLiteral(resourceName: "SignInButton") : #imageLiteral(resourceName: "SignUpButton")
        loginRegisterButton.setBackgroundImage(image, for: .normal)
        
        //Adjust inputsView
        inputsViewHeight?.constant = selected == 0 ? 100 : 150
        
        //Change textfield heights
        updateConstraint(&nameTextFieldHeight!, to: nameTextField.heightWithMultiplier(to: inputsView, multiplier: selected == 0 ? 0 : 1/3, isActive: false))
        nameTextField.isHidden = selected == 0
        updateConstraint(&emailTextFieldHeight!, to: emailTextField.heightWithMultiplier(to: inputsView, multiplier: selected == 0 ? 1/2 : 1/3, isActive: false))
        updateConstraint(&passwordTextFieldHeight!, to: passwordTextField.heightWithMultiplier(to: inputsView, multiplier: selected == 0 ? 1/2 : 1/3, isActive: false))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
