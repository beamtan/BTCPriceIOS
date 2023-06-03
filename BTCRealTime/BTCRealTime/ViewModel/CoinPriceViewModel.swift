//
//  CoinPriceViewModel.swift
//  BTCRealTime
//
//  Created by Beamtan on 1/6/2566 BE.
//

import Foundation
import SwiftUI

class CoinPriceViewModel: ObservableObject {
    @Published var btcCurrentPrice: BTCPriceModel?
    @Published var btcHistoricData: [BTCPriceModel] = []
    
    var count = 0
    
    func fetchBTCPrice() async {
        do {
            let url = URL(string: URLS.getBTCPriceURL)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoded = try JSONDecoder().decode(BTCPriceModel.self, from: data)
            self.btcCurrentPrice = decoded
            self.count += 1
            self.btcHistoricData.append(decoded)
            print(self.count)
        } catch {
            print(error)
        }
    }
    
    func startTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            Task {
                await self.fetchBTCPrice()
            }
        }
    }
    
}
