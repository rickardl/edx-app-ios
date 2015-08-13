//
//  ButtonStyle.swift
//  edX
//
//  Created by Akiva Leffert on 6/3/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation

public class ButtonStyle  {
    private let textStyle : OEXTextStyle
    private let backgroundColor : UIColor?
    private let borderStyle : BorderStyle?
    private let contentInsets : UIEdgeInsets
    
    init(textStyle : OEXTextStyle, backgroundColor : UIColor?, borderStyle : BorderStyle?, contentInsets : UIEdgeInsets? = nil) {
        self.textStyle = textStyle
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        self.contentInsets = contentInsets ?? UIEdgeInsetsZero
    }
    
    func applyToButton(button : UIButton, withTitle text : String? = nil) {
        button.setAttributedTitle(textStyle.attributedStringWithText(text), forState: .Normal)
        (borderStyle ?? BorderStyle.clearStyle()).applyToView(button)
        // Use a background image instead of a backgroundColor so that it picks up a pressed state automatically
        button.setBackgroundImage(backgroundColor.map { UIImage.oex_imageWithColor($0) }, forState: .Normal)
        button.contentEdgeInsets = contentInsets
    }
}