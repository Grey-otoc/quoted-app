//
//  EmptyArrayMessage.swift
//  Quoted
//
//  Created by Dawson McCall on 11/2/23.
//

import SwiftUI

struct EmptyArrayMessage: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.mainGray)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.mutedWhite.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.top, 35)
        .padding(.horizontal, 20)
    }
}

