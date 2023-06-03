//
//  ContentView.swift
//  BTCRealTime
//
//  Created by Beamtan on 1/6/2566 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                CoinPriceView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
