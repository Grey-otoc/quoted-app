//
//  ColorPalette.swift
//  Quoted
//
//  Created by Dawson McCall on 10/6/23.
//

import Foundation
import SwiftUI

struct ColorPalette {
    static let colors = [
        Color.paleMaroon,
        Color.sage,
        Color.washedIndigo,
        Color.raspberryGlace,
        Color.washedViolet,
        Color.greenTea,
        Color.blueJay,
        Color.mineralGreen,
        Color.papayaYellow,
        Color.sadOrange,
        Color.paradePink
    ]
}

extension Color {
    var name: String {
        switch self {
        case .papayaYellow:
            return "Papaya Yellow"
        case .paleMaroon:
            return "Pale Maroon"
        case .sage:
            return "Sage"
        case .washedIndigo:
            return "Washed Indigo"
        case .washedViolet:
            return "Washed Violet"
        case .greenTea:
            return "Green Tea"
        case .raspberryGlace:
            return "Raspberry Glace"
        case .blueJay:
            return "Blue Jay"
        case .mineralGreen:
            return "Mineral Green"
        case .sadOrange:
            return "Sad Orange"
        case .paradePink:
            return "Parade Pink"
        default:
            return "Unknown"
        }
    }
}

extension String {
    var asColor: Color {
        switch self {
        case "Papaya Yellow":
            return .papayaYellow
        case "Pale Maroon":
            return .paleMaroon
        case "Sage":
            return .sage
        case "Washed Indigo":
            return .washedIndigo
        case "Washed Violet":
            return .washedViolet
        case "Green Tea":
            return .greenTea
        case "Raspberry Glace":
            return .raspberryGlace
        case "Blue Jay":
            return .blueJay
        case "Mineral Green":
            return .mineralGreen
        case "Sad Orange":
            return .sadOrange
        case "Parade Pink":
            return .paradePink
        default:
            return .mutedWhite
        }
    }
}

extension ShapeStyle where Self == Color {
    // main app theme
    static var mutedWhite: Color {
        Color(red: 245/255, green: 245/255, blue: 245/255)
    }
    
    static var mainGray: Color {
        Color(red: 41/255, green: 42/255, blue: 51/255)
    }
    
    //card color choices
    static var papayaYellow: Color {
       Color(red: 163/255, green: 156/255, blue: 73/255)
    }
    
    static var paleMaroon: Color {
       Color(red: 161/255, green: 69/255, blue: 69/255)
    }
   
    static var sage: Color {
       Color(red: 99/255, green: 140/255, blue: 95/255)
    }
    
    static var washedViolet: Color {
       Color(red: 154/255, green: 138/255, blue: 181/255)
    }

    static var washedIndigo: Color {
       Color(red: 101/255, green: 121/255, blue: 166/255)
    }
    
    static var greenTea: Color {
       Color(red: 99/255, green: 143/255, blue: 126/255)
    }
    
    static var raspberryGlace: Color {
       Color(red: 157/255, green: 85/255, blue: 114/255)
    }
    
    static var blueJay: Color {
       Color(red: 51/255, green: 97/255, blue: 130/255)
    }
    
    static var mineralGreen: Color {
       Color(red: 53/255, green: 107/255, blue: 77/255)
    }
    
    static var sadOrange: Color {
        Color(red: 196/255, green: 113/255, blue: 75/255)
    }
    
    static var paradePink: Color {
        Color(red: 166/255, green: 116/255, blue: 158/255)
    }
}

