//
//  ContentView.swift
//  questionDay
//
//  Created by Sanya Kejriwal on 7/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var currentQuestion: Question?

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
                            .disabled(currentQuestion == nil)
                        }
            Spacer()

                      Button("Generate Question") {
                          currentQuestion = generateRandomQuestion()
                      }
        }
        .padding()
    }
    //make sure this is in the content view
    func generateRandomQuestion() -> Question {
        guard !questionBank.isEmpty else {
            fatalError("Question bank is empty. Add questions to the questionBank array.")
        }
        
        let randomIndex = Int.random(in: 0..<questionBank.count)
        return questionBank[randomIndex]
    }
    //make sure this is in the content view

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
