//
//  ContentView.swift
//  KavSoftMap
//
//  Created by Rasheed on 10/2/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SearchView()
                .navigationBarHidden(true)
        }
       
    }
}

#Preview {
    ContentView()
}
