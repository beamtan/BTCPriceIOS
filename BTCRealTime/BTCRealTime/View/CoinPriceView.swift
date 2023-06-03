//
//  CoinPriceView.swift
//  BTCRealTime
//
//  Created by Beamtan on 1/6/2566 BE.
//

import SwiftUI

struct CoinPriceView: View {
    
    let maximumBTCQuantity: Double = Double("21000000")!
    let smallestDecimalOfBTC = "%.7f"
    
    @StateObject var coinPriceViewModel = CoinPriceViewModel()
    @State var currency = "USD"
    @State var currencyList = ""
    @State private var shouldBlink: Bool = false
    
    @State var price: String = "0"
    @State var btcQuantityInOtherCurrency: String = "0"
    
    var body: some View {
        ZStack {
            Color.white
//            LinearGradient(colors: [.orange, .red],
//                                   startPoint: .top,
//                                   endPoint: .center)
            .ignoresSafeArea()
            VStack {
                if let btcCurrentPrice = coinPriceViewModel.btcCurrentPrice {
                    Text("Price of \(btcCurrentPrice.chartName ?? "")")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                    VStack {
                        ForEach(Array(btcCurrentPrice.bpi!.keys), id: \.self) { key in
                            HStack {
                                Text("\(key): ")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                Text("\(btcCurrentPrice.bpi?[key]?.rate ?? "")")
                                    .foregroundColor(shouldBlink ? Color.red: Color.black)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .onReceive(coinPriceViewModel.objectWillChange) { _ in
                                        shouldBlink = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            shouldBlink = false
                                        }
                                    }
                                Text(getSymbol(forCurrencyCode: key)!)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.neuBackground)
                            )
                            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Choose your currency")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                    
                    HStack {
                        ForEach(Array(btcCurrentPrice.bpi!.keys), id: \.self) { key in
                            Button(action: {
                                currency = key
                            }, label: {
                                Text(key)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.black)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(currency == key ? Color.blue : Color.white, lineWidth: 1)
                                    )
                            })
                        }
                    }
                    .padding()
                    
                    Text("BTC Converter")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                    HStack(alignment: .center, spacing: 0) {
                        TextEditor(text: $price)
                            .frame(maxHeight: 50)
                            .background(Color.orange)
                            .padding()
                            .onChange(of: [price, currency, btcCurrentPrice.bpi?[currency]?.rate!]) { newValue in
                                if newValue[0]!.isEmpty {
                                    btcQuantityInOtherCurrency = "0"
                                } else {
                                    let numberFormatter = NumberFormatter()
                                    if numberFormatter.number(from: newValue[0]!) != nil {
                                        let price = Double(newValue[0]!) ?? 0.0
                                        let rate = (btcCurrentPrice.bpi?[currency]?.rate_float!) ?? 0.0
                                        let x = price / rate
                                        let btcQuantity = Double(round(10000000 * x) / 10000000)
                                        
                                        btcQuantityInOtherCurrency = btcQuantity > maximumBTCQuantity ? String(maximumBTCQuantity) : String(format: smallestDecimalOfBTC, btcQuantity)
                                        if btcQuantity > maximumBTCQuantity {
                                            self.price = String(self.price.dropLast())
                                        }
                                    } else {
                                        price = "0.0"
                                    }
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding()
                        
                    }
                    HStack {
                        Text("\(currency)")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        Text("\(btcQuantityInOtherCurrency) ")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .padding()
                            .background(Color.white)
                        Text("BTC")
                    }
                    .padding()
                    
                    NavigationLink(destination: HistoryPriceDataView(
                        coinPriceViewModel: coinPriceViewModel,
                        currency: $currency
                    ), label: {
                        Text("View BTC history data")
                    })
                    
                } else {
                    Image("BTC")
                }
            }
        }
        .onAppear {
            Task {
                await coinPriceViewModel.fetchBTCPrice()
            }
            coinPriceViewModel.startTimer()
        }
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
}

struct CoinPriceView_Previews: PreviewProvider {
    static var previews: some View {
        CoinPriceView()
    }
}

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

