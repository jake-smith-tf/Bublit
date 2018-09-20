//
//  ViewController.swift
//  Bublit
//
//  Created by Jake Smith on 28/12/2017.
//  Copyright © 2017 Nebultek. All rights reserved.
//

import UIKit
import VideoBackgroundViewController
import TextFieldEffects
import Firebase

class InitialVC: VideoBackgroundViewController, UITextFieldDelegate {

    
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var loginVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "homeVideo", ofType: "mp4")!)
        self.alpha = 0.55
        
        usernameField.layer.opacity = 0.0
        passwordField.layer.opacity = 0.0
        
        usernameField.isEnabled = false
        passwordField.isEnabled = false
    }

    func signIn() {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!, completion: {
            user, error in
            if error != nil {
                self.logoText.fadeTransition(0.5)
                self.logoText.text =  "Try Again ❌"
            }
            else {
                UserDetails.UID = (user?.uid)!
                UserDetails.email = (user?.email)!
                
                self.performSegue(withIdentifier: "gotoMain", sender: self)
            }
        })
    }

    @IBAction func logInToggle(_ sender: UIButton) {
        if loginVisible {
            usernameField.isEnabled = false
            passwordField.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.usernameField.layer.opacity = 0.0
                self.passwordField.layer.opacity = 0.0
            }
            loginButton.fadeTransition(0.5)
            loginButton.setTitle("LOG IN", for: .normal)
            loginButton.backgroundColor = #colorLiteral(red: 0.01530710869, green: 0.6127827756, blue: 0.8450394273, alpha: 1)
            logoText.fadeTransition(0.5)
            logoText.text =  " Bublit ➤"
            signupButton.fadeTransition(0.5)
            signupButton.setTitle("SIGN UP", for: .normal)
            signupButton.backgroundColor = #colorLiteral(red: 0.6203879118, green: 0.7710448503, blue: 0.1789158881, alpha: 1)
            loginVisible = false
        } else {
            usernameField.isEnabled = true
            passwordField.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.usernameField.layer.opacity = 1.0
                self.passwordField.layer.opacity = 1.0
            }
            loginButton.fadeTransition(0.5)
            loginButton.setTitle("CANCEL", for: .normal)
            loginButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            logoText.fadeTransition(0.5)
            logoText.text =  "Login ✅"
            signupButton.fadeTransition(0.5)
            signupButton.setTitle("SUBMIT", for: .normal)
            signupButton.backgroundColor = #colorLiteral(red: 0.9825585937, green: 0.5185248508, blue: 0.2223238295, alpha: 1)
            usernameField.becomeFirstResponder()
            loginVisible = true
        }
    }
    
    @IBAction func rightButtonToggle(_ sender: UIButton) {
        if loginVisible {
            // Sign In
            signIn()
        } else {
            // Sign Up
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = view.viewWithTag(textField.tag + 1) as? UITextField
        textField.resignFirstResponder()
        nextField?.becomeFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

private var kAssociationKeyMaxLength: Int = 0
private var kOnlyAllowAlphaNumeric: Bool = false

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @IBInspectable var alphanumericOnly: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &kOnlyAllowAlphaNumeric) as? Bool {
                return value
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &kOnlyAllowAlphaNumeric, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkAlphaNumeric), for: .editingChanged)
        }
    }
    
    @objc func checkAlphaNumeric(textField: UITextField) {
        if alphanumericOnly == true {
            text = text?.lowercased()
            let invalidChars = NSCharacterSet.alphanumerics.inverted
            
            //let allowthismate = ["-",".","_"]
            //let union = invalidChars.
            
            text = text?.trimmingCharacters(in: invalidChars)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}
