//
//  ContentView.swift
//  ReadWeblocFile
//
//  Created by syclonefx on 6/17/24.
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
      print("Text webloc")
      readTextFile()
      print("Binary webloc")
      readBinaryFile()
    }
  }
  
  func readBinaryFile() {
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
  
  func readTextFile() {
    if let path = Bundle.main.path(forResource: "link2", ofType: "webloc") {
      print("path: \(path)")
      do {
        let data = try String(contentsOfFile: path)
        print(data)
      } catch {
        print("error: \(error.localizedDescription)")
      }
    }
  }
  
}

#Preview {
  ContentView()
}
