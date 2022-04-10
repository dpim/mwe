//
//  Date.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/10/22.
//

import Foundation

func formattedDate(_ date: Date) -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd, yyyy"
    let epoch = date.timeIntervalSince1970/1000
    let updatedDate = Date(timeIntervalSince1970: epoch)
    return dateFormatterPrint.string(from: updatedDate)
}
