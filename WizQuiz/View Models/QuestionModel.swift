//
//  QuestionModel.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class QuestionModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    var questions: [QAData]?
    var filteredQuestions: [QAData]?
    let defaults = UserDefaults.standard

    func saveUserDefaults() {
        let encodedData = try? PropertyListEncoder().encode(questions)
        defaults.set(encodedData, forKey: "questions")
    }

    func isFirstTime() -> Bool {
        return defaults.string(forKey: "version") == nil
    }

    func getVersion() {
        networkClient.getVersionNumber { version in
            self.defaults.set(version, forKey: "version")
        }
    }

    func getStarterQuestions(completion: @escaping () -> Void) {
        if let data = defaults.object(forKey: "questions") as? Data,
            let decodedData = try? PropertyListDecoder().decode([QAData].self, from: data) {
            // data is saved
            print("using saved data")
            self.questions = decodedData
            self.filteredQuestions = questions
            completion()
        } else {
            // no data saved, get some
            print("getting new data")
            getNewStarterQuestions()
            completion()
        }
    }

    func getNewStarterQuestions() {
        networkClient.getStarterQuestionData { questions in
            DispatchQueue.main.async {
                print("STARTER QUESTION COUNT: \(questions?.count ?? 0)")
                self.questions = questions
                self.filteredQuestions = self.questions
                print("CURRENT TOTAL: \(self.questions?.count ?? 0)")
                self.saveUserDefaults()
            }
            self.getVersion()
            self.getAllQuestions()
        }
    }

    func getAllQuestions() {
        networkClient.getAllQuestionData { questions in
            DispatchQueue.main.async {
                print("ALL QUESTION COUNT: \(questions?.count ?? 0)")
                self.questions? += questions!
                self.filteredQuestions = self.questions
                print("CURRENT TOTAL: \(self.questions?.count ?? 0)")
                self.saveUserDefaults()
            }
        }
    }

    func filterQuestions(_ selections: [Selection]?) {
        guard let selections = selections else { return }
        let selected = selections.filter({$0.selected == true}).compactMap({$0.name})
        filteredQuestions = questions?.filter { selected.contains($0.category) }
        filteredQuestions?.forEach { print($0.category) }
    }

    func getRandomQuestion() -> QAData {
        guard let filteredQuestions = filteredQuestions else { return QAData() }
        let max = filteredQuestions.count
        let index = arc4random_uniform(UInt32(max))
        return filteredQuestions[Int(index)]
    }
}