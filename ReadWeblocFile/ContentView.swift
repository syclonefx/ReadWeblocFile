//
//  ContentView.swift
//  ReadWeblocFile
//
//  Created by Chuck Perdue on 6/17/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      readFile()
    }
  }
  
  func readFile() {
    if let path = Bundle.main.path(forResource: "link", ofType: "webloc") {
      print("path: \(path)")
      
      if let url = URL(string: path) {
        do {
          let data = try Data(contentsOf: url)
          let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
          print("plist")
        } catch {
          print("error: \(error.localizedDescription)")
        }
      }
    }
    
    
  }
}

#Preview {
  ContentView()
}
