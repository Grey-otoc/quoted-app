//
//  AddBookTextField.swift
//  Quoted
//
//  Created by Dawson McCall on 10/9/23.
//

import SwiftUI

struct AddBookTextField: View {
    let headline: String
    @Binding var mainInfo: String
    let placeholder: String
    let selectedColor: Color
    let needsNumpad: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(headline)
                .font(.headline)
                .foregroundStyle(selectedColor)
            
            TextField(
                "",
                text: $mainInfo,
                prompt: Text(placeholder).foregroundStyle(.mainGray.opacity(0.35))
            )
            .font(.title)
            .foregroundStyle(.mainGray)
            .tint(.mainGray)
            .keyboardType(needsNumpad ? .numberPad : .default)
            .onChange(of: mainInfo) {
                if needsNumpad && mainInfo.count > 5 {
                    let index = mainInfo.index(mainInfo.startIndex, offsetBy: 5)
                    mainInfo = String(mainInfo[..<index])
                }
            }
            .autocorrectionDisabled(true)
        }
        .padding(.leading, 15)
        .padding(.trailing, 5)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .background(.mutedWhite)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 20)
    }
}
