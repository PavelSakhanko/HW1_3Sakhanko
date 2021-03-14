//
//  AppSettings.swift
//  DebtsControlBeta
//
//  Created by Pavel Sakhanko on 3.10.20.
//

import Foundation

struct Defaults {
    static let appPin = "appPin"
}

protocol AppSettingsServicing: AnyObject {
    static var apiType: String { get set }
}

class AppSettingsService: AppSettingsServicing {
    static var apiType: String {
        get { UserDefaults.standard.string(forKey: Defaults.appPin) ?? "" }
        set(value) { UserDefaults.standard.set(value, forKey: Defaults.appPin) }
    }
}
