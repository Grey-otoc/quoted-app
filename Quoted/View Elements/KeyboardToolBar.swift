//
//  KeyboardToolBar.swift
//  Quoted
//
//  Created by Dawson McCall on 11/3/23.
//

import SwiftUI

struct KeyboardToolBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            Text("Done")
                .foregroundStyle(.mutedWhite)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 25)
        .padding(.bottom, 10)
    }
}
