//
//  ScanView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/13/23.
//
//

import CoreData
import PhotosUI
import SwiftUI
import UIKit
import Vision
import VisionKit

@MainActor
struct ScanView: View {
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    let moc: NSManagedObjectContext
    let selectedColor: Color
    @Binding var tabSelection: Int
    @Binding var scannedText: String
    
    @State private var scanType = "camera.fill"
    let scanTypes = ["camera.fill", "photo.stack.fill"]
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isImageLoaded = false
    @State private var selectedText = ""
    let interaction = ImageAnalysisInteraction()
    let analyzer = ImageAnalyzer()
    
    @State private var isCameraAccessDenied = false
    @State private var deviceSupportsLiveText = false
    @State private var showSupportFailureAlert = false
    @State private var showAddedTextAlert = false
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // Picker to select capture or image picker
                    Picker("Scan Type", selection: $scanType) {
                        ForEach(scanTypes, id: \.self) { type in
                            HStack {
                                Image(systemName: type)
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    .onAppear() {
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(selectedColor)
                        UISegmentedControl.appearance().backgroundColor = UIColor(red: 16/255, green: 19/255, blue: 28/255, alpha: 1.0)
                    }
                    
                    // add image button
                    Button {
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(selectedColor)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 5.5)
                    .padding(.horizontal, 14)
                    .background(.mutedWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .sheet(isPresented: $showingImagePicker) {
                        if scanType == "photo.stack.fill" {
                            PhotoPicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        } else {
                            PhotoPicker(selectedImage: $selectedImage, sourceType: .camera)
                        }
                    }
                    .alert(isPresented: $showSupportFailureAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Live Text not available on this device."),
                            dismissButton: .cancel(Text("OK")) {
                                tabSelection = 0
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // image view with LiveText
                if let selectedImage = selectedImage {
                    //LiveTextInteractionView(selectedImage: selectedImage, interaction: interaction, analyzer: analyzer)
                    LiveTextInteraction(selectedImage: selectedImage, analyzer: analyzer, interaction: interaction)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(20)
                        .id(UUID())
                }
                
                Spacer()
                
                // add and finish quote buttons
                HStack {
                    Button("Add to Quote") {
                        if interaction.hasActiveTextSelection {
                            selectedText += interaction.selectedText
                            showAddedTextAlert = true
                            interaction.resetTextSelection()
                        }
                    }
                    .foregroundStyle(selectedColor)
                    .padding(.horizontal, 3)
                    .background(.mutedWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .alert(
                        "Added Selection to Quote.",
                        isPresented: $showAddedTextAlert
                    ) {
                        Button(role: .cancel) {} label: {
                            Text("Ok")
                        }
                    }
                    
                    Spacer()
                    
                    Button("Finish") {
                        scannedText += selectedText
                        selectedText = ""
                        selectedImage = nil
                        tabSelection = 0
                    }
                    .foregroundStyle(!selectedText.isEmpty ? selectedColor : selectedColor.opacity(0.4))
                    .disabled(selectedText.isEmpty)
                    .padding(.horizontal, 5)
                    .background(.mutedWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 15)
            .padding(.bottom, 20)
            .background(.mainGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text("Scan Quote")
                        .font(.custom("Alte Haas Grotesk Bold", size: 20))
                        .foregroundStyle(.mutedWhite)
                }
                
                // dismiss button
                ToolbarItem(placement: .topBarLeading) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(selectedColor)
                    .font(.title2)
                    .animation(.easeIn, value: selectedColor)
                }
            }
            .alert(isPresented: $isCameraAccessDenied) {
                Alert(
                    title: Text("Error"),
                    message: Text("Camera access required to capture images."),
                    primaryButton: .cancel(Text("OK")) {
                        tabSelection = 0
                    },
                    secondaryButton: .default(Text("Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    })
                )
            }
        }
        .tint(selectedColor)
        .onAppear {
            deviceSupportsLiveText = ImageAnalyzer.isSupported
            if !deviceSupportsLiveText {
                showSupportFailureAlert = true
            }
            
            cameraAccessPermitted()
        }
        .readSize { newSize in
            viewSize = newSize
        }
    }
    
    // determine if camera access is permitted
    func cameraAccessPermitted() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .denied || cameraAuthorizationStatus == .restricted {
            print("user has denied access to camera")
            isCameraAccessDenied = true
        }
    }
}
