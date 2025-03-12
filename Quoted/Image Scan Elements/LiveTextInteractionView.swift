//
//  LiveTextInteractionView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/20/23.
//

import SwiftUI
import VisionKit

struct LiveTextInteractionView: View {
    var selectedImage: UIImage
    let interaction: ImageAnalysisInteraction
    let analyzer: ImageAnalyzer
    
    var body: some View {
        LiveTextInteraction(selectedImage: selectedImage, analyzer: analyzer, interaction: interaction)
            .frame(width: 360, height: 525)
            .id(UUID())
    }
}
