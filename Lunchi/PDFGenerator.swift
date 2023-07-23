//
//  PDFGenerator.swift
//  Lunchi
//
//  Created by Raul Villarreal on 22/07/23.
//

import Foundation

func generatePdf(withTitle title: String, withIngredients ingredients: [String], withSteps steps: [String], withTime time: String) async -> Result<Data, Error> {
    // Create a Process instance to execute the Python script
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/local/bin/python3") // Python path

    if let scriptURL = Bundle.main.url(forResource: "generate_pdf", withExtension: "py") {
        // Convert the arrays to JSON strings
        let ingredientsJSON = try? JSONEncoder().encode(ingredients)
        let stepsJSON = try? JSONEncoder().encode(steps)
        
        // Convert the data to UTF-8 string
        let ingredientsString = String(data: ingredientsJSON ?? Data(), encoding: .utf8) ?? ""
        let stepsString = String(data: stepsJSON ?? Data(), encoding: .utf8) ?? ""
        
        process.arguments = [scriptURL.path, title, ingredientsString, stepsString, time]
    } else {
        print("Error: Python script not found in the app bundle.")
        return .failure(NSError(domain: "PythonScriptError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Python script not found in the app bundle"]))
    }

    let pipe = Pipe()
    process.standardOutput = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        // Return the PDF data as Data
        return .success(data)
    } catch {
        return .failure(error)
    }
}
