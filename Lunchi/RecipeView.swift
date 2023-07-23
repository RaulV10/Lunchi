//
//  ContentView.swift
//  Lunchi
//
//  Created by Raul Villarreal on 21/07/23.
//

import PDFKit
import AppKit
import SwiftUI

struct RecipeView: View {
    @State private var recipeTitle = "No recipe Available"
    @State private var recipeTime = ""
    @State private var recipeIngredients = [] as [String]
    @State private var recipeSteps = [] as [String]
    @State private var type = ""
    @State private var fetching = false
    @State private var isDownloading = false
    
    @AppStorage("recipeType") var recipeType: RecipeType = .breakfast
    @AppStorage("mustInclude") private var mustInclude: String = ""
    @AppStorage("dontInclude") private var dontInclude: String = ""
    @AppStorage("apiKey") private var apiKey: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("bitmoji")
                    .resizable()
                    .frame(width: 80, height: 80)
                VStack {
                    ForEach(RecipeType.allCases, id: \.self) { item in
                        Button {
                            recipeType = item
                            type = recipeType.type
                            Task {
                                await getRecipe(withType: item.type)
                            }
                        } label: {
                            Text(item.rawValue)
                                .foregroundColor(item == recipeType ? .mint : Color.primary)
                        }
                    }
                }
                .frame(height: 130)
            }
            if fetching {
                ProgressView()
            } else {
                VStack(alignment: .center) {
                    Text(recipeTitle)
                        .minimumScaleFactor(0.5)
                    if recipeTitle != "No recipe Available" {
                        Spacer()
                        
                        Button {
                            // Generate and download PDF
                            Task {
                                await downloadPDF()
                            }
                        } label: {
                            Text("Download Recipe")
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(height: recipeTitle != "No recipe Available" ? 80 : 20)
            }
            Spacer()
        }
        .padding()
    }
    
    func getRecipe(withType type: String) async {
        fetching = true
                
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/python3") // Python path
        process.currentDirectoryURL = Bundle.main.bundleURL
        
        let scriptURL = Bundle.main.url(forResource: "fetching_recipe", withExtension: "py")!
        
        do {
            process.arguments = [scriptURL.path, apiKey, type, mustInclude, dontInclude]
            
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe
            
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                // Convert the JSON data to Swift dictionary
                if let jsonData = output.data(using: .utf8),
                   let recipeDict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    recipeTitle = recipeDict["Title"] as? String ?? "Not recipe Available"
                    recipeIngredients = recipeDict["Ingredients"] as? [String] ?? []
                    recipeSteps = recipeDict["Steps"] as? [String] ?? []
                    recipeTime = recipeDict["Time"] as? String ?? ""
                } else {
                    print("Error: Failed to convert JSON data.")
                }
            }
        } catch {
            recipeTitle = "No recipe Available"
            print("Error executing Python script: \(error)")
        }
        fetching = false
    }
    
    func downloadPDF() async {
        isDownloading = true
        
        // Call the Python script to generate the PDF
        let result = await generatePdf(withTitle: recipeTitle, withIngredients: recipeIngredients, withSteps: recipeSteps, withTime: recipeTime)
        switch result {
        case .success(let pdfData):
            do {
                // Get the downloads directory URL
                let downloadsURL = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                let pdfURL = downloadsURL.appendingPathComponent("\(recipeTitle).pdf")

                try pdfData.write(to: pdfURL, options: .atomic)
                
            } catch {
                print("Error saving PDF: \(error)")
            }
        case .failure(let error):
            print("Error generating PDF: \(error)")
        }
        isDownloading = false
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .frame(width: 225, height: 225)
    }
}
