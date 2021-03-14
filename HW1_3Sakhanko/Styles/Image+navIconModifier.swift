//
//  Image+navIconModifier.swift
//  HW_1_2_ Sakhanko
//
//  Created by Pavel Sakhanko on 1.02.21.
//

import SwiftUI

extension Image {
    func navIconModifier() -> some View {
        self
            .frame(width: 30)
            .padding()
            .foregroundColor(.red)
    }
}
