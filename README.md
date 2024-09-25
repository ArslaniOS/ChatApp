# ChatApp
##Documentation: Implementation and Design Decisions
#Main Features
#End-to-End Encryption
#Feature: The core feature of this app is to securely encrypt and decrypt text messages between two users using iOS's built-in cryptographic APIs (CryptoKit) and Curve25519 key agreement.
#Design Decision:
iOS’s CryptoKit was chosen as it offers high-level APIs to implement cryptographic protocols without relying on third-party libraries. This allows for secure, reliable, and efficient encryption.
Curve25519 Key Agreement is used for key exchange between two users to derive a shared symmetric key.
ChaChaPoly encryption is selected for its performance and security, ensuring efficient and secure message encryption.

##Key Management
#Feature: The app derives a symmetric key for encrypting and decrypting messages based on each user’s Curve25519 key agreement keys (private/public key pairs).
#Design Decision:
A secure key exchange mechanism is assumed, meaning users exchange public keys via an out-of-band method (e.g., QR codes, secure physical exchange).
Symmetric keys are derived using the shared secret from the key agreement, ensuring messages are encrypted with keys that are never transmitted over the network.
Message Encryption/Decryption
Feature: Messages are encrypted using the symmetric key before being sent and decrypted using the same key upon reception.
Design Decision:
Each message is encrypted with ChaChaPoly, ensuring both confidentiality and integrity.
On reception, the symmetric key is used to decrypt the encrypted message and display it.
Error Handling
Feature: The app handles errors related to cryptography, key management, and message encryption/decryption gracefully.
Design Decision:
Custom error types (CryptoError) were defined for handling encryption and decryption errors.
User-friendly error messages are displayed using SwiftUI alerts, providing feedback when something goes wrong (e.g., encryption fails, key agreement fails).
Invalid inputs and cryptographic failures result in alerts with relevant messages.
Architectural Design
The MVVM (Model-View-ViewModel) architecture was chosen for the following reasons:

Separation of Concerns: It cleanly separates the business logic (encryption/decryption, key exchange) from the UI code, making the code more maintainable and scalable.
State Management: Using @StateObject in SwiftUI allows the ViewModel to manage the state of the views, updating the UI when the message list or encryption states change.
Error Handling: The ViewModel manages errors and updates the view to show alerts, keeping the UI code simple.
Classes and Components
CryptoManager: Handles encryption and decryption of messages using the symmetric key derived from key agreement.
KeyExchangeManager: Manages the key agreement process using the Curve25519 algorithm.
MessagingViewModel: Holds the business logic, including managing users, handling key exchange, encrypting and decrypting messages, and error handling.
ContentView: The main SwiftUI view that displays the messaging UI, with a text input for new messages and a list showing the message history.
