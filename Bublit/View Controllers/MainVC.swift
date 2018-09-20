//
//  MainVC.swift
//  Bublit
//
//  Created by Jake Smith on 28/12/2017.
//  Copyright © 2017 Nebultek. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITextFieldDelegate, MapVCDelegate {
    
    
    

    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var mapView: UIView!
    
    var containerViewController: MapVC?
    var originalOrigin: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalOrigin = self.view.frame.origin.y
        chatField.delegate = self
        containerViewController = self.childViewControllers.first as? MapVC
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        chatField.layer.opacity = 0.7
        containerViewController?.delegate = self
        
        
        
    }
    
    func userTapped() {
        view.endEditing(true)
    }

    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        containerViewController?.mapView.animate(toLocation: (containerViewController?.marker.position)!)
        self.view.frame.origin.y = originalOrigin! - keyboardHeight
        UIView.animate(withDuration: 0.8) {
            self.chatField.layer.opacity = 1
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = originalOrigin!
            UIView.animate(withDuration: 0.8) {
                self.chatField.layer.opacity = 0.7
            }
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        containerViewController?.userMap.deviceMarker.snippet = textField.text!+""
        containerViewController?.mapView.selectedMarker = containerViewController?.userMap.deviceMarker
        containerViewController?.mapView.animate(toLocation: (containerViewController?.userMap.deviceMarker.position)!)
        textField.resignFirstResponder()
        textField.text?.removeAll()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
