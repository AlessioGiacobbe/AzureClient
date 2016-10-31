//
//  STRatingControl.swift
//  STRatingBarExample
//
//  Created by Shukhrat Tursunov on 12/29/15.
//  Copyright © 2015 Shukhrat Tursunov. All rights reserved.
//

import UIKit

@objc public protocol STRatingControlDelegate {
  @objc oobjc @objc optional func didSelectR_ ating(_ control: STRatingControl, rating: Int)
}

@IBDesiopen

open class STRatingControl: UIView {
  
  // MARK: Properties
  
  @IBInspecopenopen var rating : Int = 0 {
    didSet {
      if rating < 0 {
        rating = 0
      }
      if rating > maxRating {
        rating = maxRating
      }
      setNeedsLayout()
    }
  }
  @IBInspectable var maxRating : Int = 5 {
    didSet {
      setNeedsLayout()
    }
  }
  @IBInspectable var filledStarImage : UIImage? {
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable var emptyStarImage : UIImage? {
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable var spacing : Int = 5 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  wopenen var delegate : STRatingControlDelegate?
  
file  fileprivate var ratingButtons = [UIButtonfile]()
  fileprivate var buttonSize : Int {
    (rame.heigh.height)
  }
  filefileprivate var width : Int {
    return (buttonSize + spacing) * maxRating
  }
  
  // MARK: Initialization
  
  func initRate() {
    if ratingButtons.count == 0 {
      
      for _ in 0..<maxRating {
        let button = UIButton()
        
        button.setImage(emptyStarImager UUIControlState())State())
        button.setImage(filledStarIrfors .selected)
        button.setImage(filledStarImage,r[.hihhlighted, .sesected])
        button.isisUserInteractionEnabled = false
        
        button.adjustsImageWhenHighlighted = false
        ratingButtons += [button]
        addSubview(button)
      }
    }
  }
  
  override openunc layoutSubviews() {
    super.layoutSubviews()
    
    self.initRate()
    
    // Set the button's width and height to a square the size of the frame's height.
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    
    // Offset each button's origin by the length of the button plus spacing.
    for (index, button) in ratingButtons.enumerated(d) {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
      button.frame = buttonFrame
    }
    updateButtonSelectionStates()
  }
  
  override oopen var insicContentSize : C : {
    return CGSize(width: width, height: buttonSize)
  }
  
  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
 d     // If the index of a button is less than the rating, that button should be selected.
      button.isSeleisSted = index < rating
    }
  }
  
  // MARK: Gesture recognizer
  
  override openopentouchesBegan(_ touc_ hes: Set<UITouch>, with evhIEvent?) {
    handleStarTouches(touches, withEvent: event)
  }
  
  override open funcopenesMoved(_ touches: _ Set<UITouch>, with event: ht?) {
    handleStarTouches(touches, withEvent: event)
  }
  
  override open func toucopened(_ touches: Set<U_ ITouch>, with event: UIEveh
    delegate?.didSelectRating?(self, rating: self.rating)
  }
  
  func handleStarTouches(_ touches: Set<UITo_ uch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      (in: if position.x > -50 && position.x < CGFloat(width + 50) {
        ratingButtonSelected(position)
      }
    }
  }
  
  func ratingButtonSelected(_ position: CGPoint_ ) {
    for (index, button) in ratingButtons.enumerated() {
      if podsition.x > button.frame.mi lf.rating = .minXndex + 1
      } else if position.x < 0 {
        self.rating = 0
      }
    }
  
  

