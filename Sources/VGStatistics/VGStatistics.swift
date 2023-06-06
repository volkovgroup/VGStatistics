import Foundation
import SwiftUI
import CoreGraphics
import CoreText

let fonts = VGStatisticsFonts()

extension UIFont {
    var suFont: Font {
        Font(self)
    }
}

extension UIColor {
    var suColor: Color {
        Color(self)
    }
}

enum Semantic {
    static var title: UIColor {
        UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.00)
    }
    
    static var subtitle: UIColor {
        title.withAlphaComponent(0.6)
    }
}

enum ImportedFonts: String, CaseIterable {
    case montserratBoldItalic = "Montserrat-BoldItalic"
    case montserratBlack = "Montserrat-Black"
    case montserratBlackItalic = "Montserrat-BlackItalic"
    case montserratBold = "Montserrat-Bold"
    case montserratExtraBold = "Montserrat-ExtraBold"
    case montserratExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case montserratExtraLight = "Montserrat-ExtraLight"
    case montserratExtraLightItalic = "Montserrat-ExtraLightItalic"
    case montserratItalic = "Montserrat-Italic"
    case montserratLight = "Montserrat-Light"
    case montserratLightItalic = "Montserrat-LightItalic"
    case montserratMedium = "Montserrat-Medium"
    case montserratMediumItalic = "Montserrat-MediumItalic"
    case montserratRegular = "Montserrat-Regular"
    case montserratSemiBold = "Montserrat-SemiBold"
    case montserratSemiBoldItalic = "Montserrat-SemiBoldItalic"
    case montserratThin = "Montserrat-Thin"
    case montserratThinItalic = "Montserrat-ThinItalic"
}

enum Fonts {
    static var cardTitle = UIFont(name: "Montserrat-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
    static var pastTitle = UIFont(name: "Montserrat-Bold", size: 12) ?? .systemFont(ofSize: 12, weight: .bold)
    static var percentTitle = UIFont(name: "Montserrat-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
}

public class VGStatisticsFonts {
    init() {
        registerFonts()
    }
    
    private func registerFonts() {
        ImportedFonts.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }

   private func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {

       guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
             let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
             let font = CGFont(fontDataProvider) else {
                 fatalError("Couldn't create font from data")
       }

       var error: Unmanaged<CFError>?

       CTFontManagerRegisterGraphicsFont(font, &error)
   }
}

public struct VGStatistics {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}
