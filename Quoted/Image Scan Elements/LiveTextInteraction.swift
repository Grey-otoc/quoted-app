//
//  LiveTextInteraction.swift
//  Quoted
//
//  Created by Dawson McCall on 10/20/23.
//

import SwiftUI
import UIKit
import VisionKit

@MainActor
struct LiveTextInteraction: UIViewRepresentable {
    let selectedImage: UIImage
    let imageView = LiveTextImageView()
    let analyzer: ImageAnalyzer
    let interaction: ImageAnalysisInteraction
    
    func makeUIView(context: Context) -> some UIView {
        imageView.image = selectedImage
        imageView.addInteraction(interaction)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        Task {
            let configuration = ImageAnalyzer.Configuration([.text])
            imageView.image = selectedImage
            
            do {
                if let image = imageView.image {
                    if let analysis = try await analyzer.analyze(image, configuration: configuration) as ImageAnalysis? {
                        DispatchQueue.main.async {
                            interaction.analysis = analysis
                            interaction.preferredInteractionTypes = .textSelection
                            interaction.allowLongPressForDataDetectorsInTextMode = false
                        }
                    }
                }
            } catch {
                print("THIS ONE \(error.localizedDescription)")
            }
        }
    }
}

class LiveTextImageView: UIImageView {
    // Use intrinsicContentSize to change the default image size
    // so that we can change the size in our SwiftUI View
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
