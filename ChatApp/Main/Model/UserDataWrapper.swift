//
//  UserDataWrapper.swift
//  ChatApp
//
//  Created by Xeven Dev on 25/09/2024.
//

import Foundation
import CryptoKit

struct User {
    let id: String
    let keyAgreementPrivateKey: Curve25519.KeyAgreement.PrivateKey
    let keyAgreementPublicKey: Curve25519.KeyAgreement.PublicKey
    let signingPrivateKey: Curve25519.Signing.PrivateKey
    let signingPublicKey: Curve25519.Signing.PublicKey
    
    init(id: String) {
        self.id = id
        // Key Agreement (for key exchange)
        self.keyAgreementPrivateKey = Curve25519.KeyAgreement.PrivateKey()
        self.keyAgreementPublicKey = keyAgreementPrivateKey.publicKey
        
        // Signing (for digital signatures)
        self.signingPrivateKey = Curve25519.Signing.PrivateKey()
        self.signingPublicKey = signingPrivateKey.publicKey
    }
}

struct Message {
    let content: String
    let senderID: String
}
