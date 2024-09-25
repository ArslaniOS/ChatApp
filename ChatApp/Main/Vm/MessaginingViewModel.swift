//
//  MessaginingViewModel.swift
//  ChatApp
//
//  Created by Xeven Dev on 25/09/2024.
//

import SwiftUI
import CryptoKit

class MessagingViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var recipientUser: User
    @Published var messageText: String = ""
    @Published var messages: [Message] = []
    @Published var errorMessage: String? = nil
    
    @Published var showErrorAlert = false
    @Published var isLoading: Bool = false
    
    private var cryptoManager: CryptoManager
    private var keyExchangeManager: KeyExchangeManager
    private var symmetricKey: SymmetricKey?

    init(currentUser: User, recipientUser: User, cryptoManager: CryptoManager, keyExchangeManager: KeyExchangeManager) {
        self.currentUser = currentUser
        self.recipientUser = recipientUser
        self.cryptoManager = cryptoManager
        self.keyExchangeManager = keyExchangeManager
        
        // Derive a symmetric key for both users
        do {
            symmetricKey = try keyExchangeManager.deriveSymmetricKey(privateKey: currentUser.keyAgreementPrivateKey, publicKey: recipientUser.keyAgreementPublicKey)
        } catch {
            showError(error: "Key agreement failed: \(error.localizedDescription)")
        }
    }

    // Function to encrypt and send the message
    func sendMessage() {
        guard let symmetricKey = symmetricKey else {
            showError(error: "Failed to send message. Symmetric key is not available.")
            return
        }
        
        do {
            let encryptedMessage = try cryptoManager.encryptMessage(messageText, using: symmetricKey)
            let message = Message(content: encryptedMessage, senderID: currentUser.id)
            messages.append(message)
            messageText = ""
        } catch {
            showError(error: "Failed to encrypt message: \(error.localizedDescription)")
        }
    }
    
    // Function to decrypt the received message
    func receiveMessage(_ encryptedMessage: String) -> String? {
        guard let symmetricKey = symmetricKey else {
            showError(error: "Failed to receive message. Symmetric key is not available.")
            return nil
        }
        
        do {
            return try cryptoManager.decryptMessage(encryptedMessage, using: symmetricKey)
        } catch {
            showError(error: "Failed to decrypt message: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Function to show error message
    private func showError(error: String) {
        errorMessage = error
        showErrorAlert = true
    }
}

