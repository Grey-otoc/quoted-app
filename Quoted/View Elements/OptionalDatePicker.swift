//
//  OptionalDatePicker.swift
//  Quoted
//
//  Created by Dawson McCall on 10/7/23.
//

import SwiftUI

// source code: https://stackoverflow.com/questions/66696263/swiftui-datepicker-allow-no-date-at-all

struct OptionalDatePicker: View {
    let prompt: String
    let range: PartialRangeFrom<Date>
    let selectedColor: Color
    @Binding var date: Date?
    @State private var hiddenDate = Date()
    @State private var showDate = false
    
    init(_ prompt: String, in range: PartialRangeFrom<Date>, selection: Binding<Date?>, selectedColor: Color) {
        self.prompt = prompt
        self.range = range
        self._date = selection
        self.selectedColor = selectedColor
    }
    
    var body: some View {
        ZStack {
            HStack {
                if showDate {
                    Button {
                        showDate = false
                        date = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(selectedColor)
                    }
                    
                    DatePicker(
                        "Select a date",
                        selection: $hiddenDate,
                        in: range,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .onChange(of: hiddenDate) { oldDate, newDate in
                        date = newDate
                    }
                    .padding(.vertical, -2.5)
                    .padding(.horizontal, -4)
                    .background(.mainGray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .tint(selectedColor)
                } else {
                    Button {
                        showDate = true
                        date = hiddenDate
                    } label: {
                        Text(prompt)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.mutedWhite)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.mainGray)
                    )
                }
            }
        }
    }
}
