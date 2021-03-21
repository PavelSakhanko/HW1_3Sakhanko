//
//  AppSettings.swift
//  HW_1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 3.10.20.
//

import Foundation

struct Defaults {
    static let appPin = "appPin"
}

protocol AppSettingsServicing: AnyObject {
    var apiType: String { get set }
}

class AppSettingsService: AppSettingsServicing {
    var apiType: String {
        get { UserDefaults.standard.string(forKey: Defaults.appPin) ?? "" }
        set(value) { UserDefaults.standard.set(value, forKey: Defaults.appPin) }
    }
}
