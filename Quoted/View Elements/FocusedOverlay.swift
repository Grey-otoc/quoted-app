//
//  FocusedOverlay.swift
//  Quoted
//
//  Created by Dawson McCall on 10/26/23.
//

import SwiftUI

// disallows background tap gesture interaction when sort menu open
struct FocusedOverlay: View {
    var body: some View {
        Color.white.opacity(0.001)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FocusedOverlay()
}
