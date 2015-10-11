//
//  TextFieldWithPadding.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/11/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//
// http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone

import Foundation
import UIKit

@IBDesignable
class TextFieldWithPadding: UITextField {
    
    @IBInspectable var padding: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, padding, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
