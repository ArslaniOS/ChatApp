//
//  ContentView.swift
//  ChatApp
//
//  Created by Xeven Dev on 25/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: MessagingViewModel
    
    @State private var isUser1Active = true // Track which user is currently active
    
    init() {
        let user1 = User(id: "User1")
        let user2 = User(id: "User2")
        let cryptoManager = CryptoManager()
        let keyExchangeManager = KeyExchangeManager()
        
        _viewModel = StateObject(wrappedValue: MessagingViewModel(currentUser: user1, recipientUser: user2, cryptoManager: cryptoManager, keyExchangeManager: keyExchangeManager))
    }
    
    
    var body: some View {
        VStack {
            Toggle("User 1 Active", isOn: $isUser1Active)
                .padding()
            
            Text("Current User: \(viewModel.currentUser.id)")
                .padding()
            
            TextField("Enter message", text: $viewModel.messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send Message") {
                viewModel.sendMessage()
                toggleUser()
            }
            .padding()
            
            List(viewModel.messages, id: \.content) { message in
                if let decryptedMessage = viewModel.receiveMessage(message.content) {
                    Text("\(message.senderID): \(decryptedMessage)")
                }
            }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: isUser1Active) { _ in
            toggleUser()
        }
    }
    
    // Toggle between User 1 and User 2
    func toggleUser() {
        if isUser1Active {
            viewModel.currentUser = User(id: "User1")
            viewModel.recipientUser = User(id: "User2")
        } else {
            viewModel.currentUser = User(id: "User2")
            viewModel.recipientUser = User(id: "User1")
            
        }
    } }
struct MessagingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
