//
//  ContentView.swift
//  questionDay
//
//  Created by Sanya Kejriwal on 7/19/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var currentQuestion: Question?
    @State private var waitingForQuestion = false

    var body: some View {
        VStack {
            Text(currentQuestion?.text ?? "Tap the button to generate a question.")
                .padding()
                .font(.headline)
            
            Spacer()
            ForEach(currentQuestion?.choices ?? [], id: \.self) { choice in
                Button(action: {
                    checkAnswer(choice)
                }) {
                    Text(choice)
                        .padding()
                }
                .disabled(currentQuestion == nil || waitingForQuestion)
            }
            Spacer()
            
            Button("Generate Question") {
                       if waitingForQuestion {
                           // The user needs to wait, show the alert.
                           waitingForQuestion = true
                           DispatchQueue.main.async {
                               waitingForQuestion = false
                           }
                       } else {
                           // Generate a new question if not waiting.
                           currentQuestion = generateRandomQuestionIfNeeded()
                           waitingForQuestion = true // Set waitingForQuestion to true to trigger the alert.
                       }
                   }
                   .disabled(waitingForQuestion)
        }
        .padding()
        .alert(isPresented: $waitingForQuestion) {
            Alert(
                title: Text("Please wait!"),
                message: Text("A new question will be available in a moment."),
                dismissButton: .default(Text("Got it!")) {
                    currentQuestion = generateRandomQuestionIfNeeded()
                }

            )
        }
    }
    //make sure this is in the content view
    
    func generateRandomQuestionIfNeeded() -> Question? {
        if shouldDisplayNewQuestion() {
            guard !questionBank.isEmpty else {
                fatalError("Question bank is empty. Add questions to the questionBank array.")
            }
            
            let randomIndex = Int.random(in: 0..<questionBank.count)
            let newQuestion = questionBank[randomIndex]
            
            // Store the current date as the last date a question was displayed.
            UserDefaults.standard.set(Date(), forKey: "LastQuestionDate")
            
            return newQuestion
        } else {
            return nil // Return nil when there's no need to display a new question.
        }
    }
    
    //make sure this is in the content view

    func shouldDisplayNewQuestion() -> Bool {
        // Retrieve the last date a question was displayed (using UserDefaults).
        if let lastQuestionDate = UserDefaults.standard.object(forKey: "LastQuestionDate") as? Date {
            // Get the current date.
            let currentDate = Date()
print(currentDate)
            // Compare the last question date with the current date and check if it's a different day.
            let calendar = Calendar.current
            return !calendar.isDate(lastQuestionDate, inSameDayAs: currentDate)
        }

        // If there's no last question date (first-time use), return true to display a new question.
        return true
    }
    
    
    
    func checkAnswer(_ selectedAnswer: String) {
        guard let question = currentQuestion else {
            return
        }

        if selectedAnswer == question.correctAnswer {
            // Implement your logic for handling a correct answer other than printing.
            print("Correct!")
        } else {
            // Implement your logic for handling an incorrect answer other than printing.
            print("Incorrect!")
        }
    }

}
// this is outside of the contentview

let questionBank = [
    
    Question(text: "What is the capital of France?", choices: ["London", "Paris", "Berlin", "Madrid"], correctAnswer: "Paris"),
    Question(text: "Which planet is closest to the sun?", choices: ["Venus", "Mercury", "Mars", "Jupiter"], correctAnswer: "Mercury"),
    // Add more questions here...
]
//make sure  this is outside of the contentview struct
struct Question {
    let text: String
    let choices: [String]
    let correctAnswer: String
}

//make sure this is outside of the other structs and is last
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
