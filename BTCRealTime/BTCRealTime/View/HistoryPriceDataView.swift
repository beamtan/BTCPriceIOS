//
//  HistoryPriceDataView.swift
//  BTCRealTime
//
//  Created by Beamtan on 2/6/2566 BE.
//

import SwiftUI

struct HistoryPriceDataView: View {
    @ObservedObject var coinPriceViewModel: CoinPriceViewModel
    @Binding var currency: String
    
    var body: some View {
        Text("History Data in \(currency)")
            .font(.system(size: 20, weight: .heavy, design: .rounded))
        if coinPriceViewModel.btcHistoricData.count > 0 {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 5) {
                    ForEach(coinPriceViewModel.btcHistoricData.indices, id: \.self) { index in
                        HStack(spacing: 5) {
                            Text((coinPriceViewModel.btcHistoricData[index].bpi![currency]?.rate!)!)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            Text("|")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            Text("\(coinPriceViewModel.btcHistoricData[index].time?.updated ?? "")")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                        }
                        .padding()
                        Divider()
                    }
                }
            }
        }
    }
}

//struct HistoryPriceDataView_Previews: PreviewProvider {
//    @State var currency: String = "USD"
//    static var previews: some View {
//        HistoryPriceDataView(coinPriceViewModel: CoinPriceViewModel(), currency: $currency)
//    }
//}
