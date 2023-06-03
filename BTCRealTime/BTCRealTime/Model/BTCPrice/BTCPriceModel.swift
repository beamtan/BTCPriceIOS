//
//  BTCPriceModel.swift
//  BTCRealTime
//
//  Created by Beamtan on 1/6/2566 BE.
//

import Foundation

struct BTCPriceModel: Codable {
    var time: TimeModel? = nil
    var disclaimer: String? = ""
    var chartName: String? = ""
    var bpi: [String: CurrencyModel]? = nil
}

struct TimeModel: Codable {
    var updated: String? = ""
    var updatedISO: String? = ""
    var updateduk: String? = ""
}

struct CurrencyModel: Codable {
    var code: String? = ""
    var symbol: String? = ""
    var rate: String? = ""
    var description: String? = ""
    var rate_float: Double? = nil
}
