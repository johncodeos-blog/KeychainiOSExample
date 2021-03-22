//
//  SaveItemViewController.swift
//  KeychainiOSExample
//
//  Created by John Codeos on 3/20/21.
//

import Security
import UIKit

class SaveItemViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var resultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        resultsLabel.isHidden = true

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGes)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveBtnAction(_ sender: UIButton) {
        // Check textfields
        guard let username = usernameTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }
        guard let password = passwordTextField.text,!password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Password field is empty") }

        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!,
        ]
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            resultsLabel.text = "User saved successfully in the keychain"
        } else {
            resultsLabel.text = "Something went wrong trying to save the user in the keychain"
        }
        resultsLabel.isHidden = false
        dismissKeyboard()
    }
}
