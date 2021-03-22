//
//  DeleteItemViewController.swift
//  KeychainiOSExample
//
//  Created by John Codeos on 3/20/21.
//

import Security
import UIKit

class DeleteItemViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var resultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.autocorrectionType = .no
        resultsLabel.isHidden = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGes)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        // Check textfield
        guard let username = usernameTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }

        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]

        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            resultsLabel.text = "User removed successfully from the keychain"
        } else {
            resultsLabel.text = "Something went wrong trying to remove the user from the keychain"
        }
        resultsLabel.isHidden = false
        dismissKeyboard()
    }
}
