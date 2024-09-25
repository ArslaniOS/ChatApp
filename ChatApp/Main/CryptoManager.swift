//
//  CryptoManager.swift
//  ChatApp
//
//  Created by Xeven Dev on 25/09/2024.
//

import Foundation
import CryptoKit

enum CryptoError: Error {
    case encryptionFailed
    case decryptionFailed
    case invalidKey
}

class CryptoManager {
    
    // Encrypt the message using the symmetric key
    func encryptMessage(_ message: String, using key: SymmetricKey) throws -> String {
        let data = Data(message.utf8)
        do {
            let sealedBox = try ChaChaPoly.seal(data, using: key)
            return sealedBox.combined.base64EncodedString()
        } catch {
            throw CryptoError.encryptionFailed
        }
    }
    
    // Decrypt the message using the symmetric key
    func decryptMessage(_ encryptedMessage: String, using key: SymmetricKey) throws -> String? {
        guard let data = Data(base64Encoded: encryptedMessage) else {
            throw CryptoError.invalidKey
        }
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: data)
            let decryptedData = try ChaChaPoly.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            throw CryptoError.decryptionFailed
        }
    }
}




class KeyExchangeManager {
    
    // Derive a symmetric key from the private and public keys
    func deriveSymmetricKey(privateKey: Curve25519.KeyAgreement.PrivateKey, publicKey: Curve25519.KeyAgreement.PublicKey) throws -> SymmetricKey {
        do {
            let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
            return sharedSecret.hkdfDerivedSymmetricKey(
                using: SHA256.self,
                salt: Data(),
                sharedInfo: Data(),
                outputByteCount: 32
            )
        } catch {
            throw CryptoError.invalidKey
        }
    }
}

