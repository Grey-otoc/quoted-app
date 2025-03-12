//
//  TCPrivacyView.swift
//  Quoted
//
//  Created by Dawson McCall on 11/7/23.
//

import SwiftUI

struct TCPrivacyView: View {
    let bottomPadding = 25.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // precursor
                Section {
                    Text("By using Quoted you are consenting to our policies regarding the collection, use, and disclosure of personal information set out in this privacy policy.")
                        .padding(.bottom, bottomPadding)
                } header: {
                    Text("Precursor")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.mutedWhite)
                }
                
                // personal info
                Section {
                    Text("We do not collect, store, use or share any information, personal or otherwise.")
                        .padding(.bottom, bottomPadding)
                } header: {
                    Text("Collection of Personal Information")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.mutedWhite)
                }
                
                // email usage
                Section {
                    Text("If you email the developer for support or other feedback, the emails with email addresses will be retained for quality assurance purposes. The email addresses will be used only to reply to the concerns or suggestions raised and will never be used for any marketing purpose.")
                        .padding(.bottom, bottomPadding)
                } header: {
                    Text("Email Usage")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.mutedWhite)
                }
                
                // personal info
                Section {
                    Text("We will not disclose your information to any third party except if you expressly consent or where required by law.")
                        .padding(.bottom, bottomPadding)
                } header: {
                    Text("Disclosure of Personal Information")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.mutedWhite)
                }
                
                // contact
                Section {
                    let email = "quotedappcontact@gmail.com"
                    let str = "If you have any questions regarding this privacy policy, you can email \(email)."
                                
                    Text( (try? AttributedString(markdown: str)) ?? AttributedString(str) )
                        .padding(.bottom, bottomPadding)
                } header: {
                    Text("Contact Us")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.mutedWhite)
                }
            }
            .foregroundStyle(.mutedWhite.opacity(0.9))
            .font(.headline)
            .frame(maxWidth: .infinity)
            
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .background(.mainGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mainGray)
        .scrollIndicators(.hidden)
    }
}
