//
//  SettingsView.swift
//  Lunchi
//
//  Created by Raul Villarreal on 22/07/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            IngredientsPreferencesSettingsView()
            .tabItem {
                Label("Ingredients", systemImage: "person.crop.circle")
            }
            
            ApiSettingsView()
            .tabItem {
                Label("API KEY", systemImage: "hand.raised")
            }
        }
        .frame(width: 450, height: 250)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 225, height: 225)
    }
}

struct IngredientsPreferencesSettingsView: View {
    @AppStorage("mustInclude") private var mustInclude: String = ""
    @AppStorage("dontInclude") private var dontInclude: String = ""
    
    var body: some View {
        VStack {
            Text("Food Preferences")
                .font(.title2)
                .padding(.bottom, 20)
            
            Form {
                Section() {
                    TextField("Must include:", text: $mustInclude)
                }
                
                Section() {
                    TextField("Don't include:", text: $dontInclude)
                }
            }

            Text("Please separate all the ingredients by a comma")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
 
struct ApiSettingsView: View {
    @AppStorage("apiKey") private var apiKey: String = ""
    var body: some View {
        VStack {
            Text("OpenAI API KEY")
                .font(.title2)
                .padding(.bottom, 20)
            
            Form {
                Section() {
                    TextField("API KEY:", text: $apiKey)
                }
            }

            Text("This api key will only be stored in your computer and its needed for this app to work properly")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
