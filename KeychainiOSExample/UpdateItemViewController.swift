//
//  UpdateItemViewController.swift
//  KeychainiOSExample
//
//  Created by John Codeos on 3/20/21.
//

import Security
import UIKit

class UpdateItemViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var resultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.autocorrectionType = .no
        newPasswordTextField.autocorrectionType = .no
        resultsLabel.isHidden = true

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGes)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func updateBtnAction(_ sender: UIButton) {
        // Check textfields
        guard let username = usernameTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }
        guard let newPassword = newPasswordTextField.text,!newPassword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("new Password field is empty") }

        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]

        // Set attributes for the new password
        let attributes: [String: Any] = [kSecValueData as String: newPassword.data(using: .utf8)!]

        // Find user and update
        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
            resultsLabel.text = "Password has changed"
        } else {
            resultsLabel.text = "Something went wrong trying to update the password"
        }
        resultsLabel.isHidden = false
        dismissKeyboard()
    }
}

