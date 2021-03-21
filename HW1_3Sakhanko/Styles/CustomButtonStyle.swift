//
//  CustomButtonStyle.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 21.03.21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @State var width = UIScreen.main.bounds.width

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.title)
            .padding(.vertical)
            .frame(width: self.width - 50)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}
