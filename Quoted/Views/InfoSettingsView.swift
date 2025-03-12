//
//  InfoSettingsView.swift
//  Quoted
//
//  Created by Dawson McCall on 11/1/23.
//

import SwiftUI

struct InfoSettingsView: View {
    private let appUrl = URL(string: "https://www.apple.com")! // will change after app release
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    // support
                    Section {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Report an Issue")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openMail(
                                emailTo: "quotedappcontact@gmail.com",
                                subject: "User Support",
                                body: "Having an issue? Let us know!"
                            )
                        }
                        
                        HStack {
                            Image(systemName: "paperplane.circle.fill")
                            Text("Provide Feedback")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openMail(
                                emailTo: "quotedappcontact@gmail.com",
                                subject: "User Support",
                                body: "Want to suggest a feature or share your experience? Let us know!"
                            )
                        }
                    } header: {
                        Text("Get Support")
                            .font(.headline)
                            .foregroundStyle(.mutedWhite.opacity(0.65))
                    }
                    .foregroundStyle(.mainGray)
                    .font(.title3)
                    .listRowBackground(Color.mutedWhite)
                    
                    // share and rate
                    Section {
//                        ShareLink(
//                            item: "String",
//                            label: {
//                                HStack {
//                                    Image(systemName: "square.and.arrow.up.circle.fill")
//                                    Text("Share")
//                                    Spacer()
//                                }
//                                .contentShape(Rectangle())
//                            }
//                        )
                        Button {
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6471858701") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "star.circle")
                                Text("Rate the App")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                    } header: {
                        Text("Help Us Grow")
                            .font(.headline)
                            .foregroundStyle(.mutedWhite.opacity(0.65))
                    }
                    .foregroundStyle(.mainGray)
                    .font(.title3)
                    .listRowBackground(Color.mutedWhite)
                    
                    // legals
                    Section {
                        NavigationLink(
                            destination: TCPrivacyView(),
                            label: {
                                HStack {
                                    Image(systemName: "doc.circle.fill")
                                    Text("Terms, Conditions, and Privacy")
                                    Spacer()
                                }
                            }
                        )
                        .navigationBarTitle("", displayMode: .inline) // removes "back" text from navbar
                    } header: {
                        Text("Legal Information")
                            .font(.headline)
                            .foregroundStyle(.mutedWhite.opacity(0.65))
                    }
                    .foregroundStyle(.mainGray)
                    .font(.title3)
                    .listRowBackground(Color.mutedWhite)
                }
                .padding(.top, 10)
                .background(.mainGray)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainGray)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text("Quoted Info")
                        .font(.custom("Alte Haas Grotesk Bold", size: 20))
                        .foregroundStyle(.mutedWhite)
                }
            }
        }
    }
}

func openMail(emailTo:String, subject: String, body: String) {
    if let url = URL(string: "mailto:\(emailTo)?subject=\(subject.fixToBrowserString())&body=\(body)"),
       UIApplication.shared.canOpenURL(url)
    {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension String {
    func fixToBrowserString() -> String {
        self.replacingOccurrences(of: ";", with: "%3B")
            .replacingOccurrences(of: "\n", with: "%0D%0A")
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "\"", with: "%22")
            .replacingOccurrences(of: "\\", with: "%5C")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: "‘", with: "%91")
            .replacingOccurrences(of: ",", with: "%2C")
    }
}
