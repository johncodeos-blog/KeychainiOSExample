//
//  RetrieveItemViewController.swift
//  KeychainiOSExample
//
//  Created by John Codeos on 3/20/21.
//

import Security
import UIKit

class RetrieveItemViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var resultsStackView: UIStackView!
    @IBOutlet var resultsLabel: UILabel!
    @IBOutlet var resultsUsernameLabel: UILabel!
    @IBOutlet var resultsPasswordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.autocorrectionType = .no
        resultsStackView.isHidden = true
        resultsLabel.isHidden = true

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGes)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func searchBtnAction(_ sender: UIButton) {
        // Check textfield
        guard let username = usernameTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }
        
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            resultsLabel.isHidden = true
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                resultsStackView.isHidden = false
                resultsUsernameLabel.text = username
                resultsPasswordLabel.text = password
            }
        } else {
            resultsLabel.isHidden = false
            resultsLabel.text = "Something went wrong trying to find the user in the keychain"
        }
        dismissKeyboard()
    }
}
