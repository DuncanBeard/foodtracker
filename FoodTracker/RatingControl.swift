//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Duncan Beard on 8/14/16.
//  Copyright © 2016 Duncan Beard. All rights reserved.
//

import UIKit

class RatingControl: UIView {

    // MARK: Properties

    var rating = 0 {
        // Observer for when this property changes
        didSet {
            // Trigger a layout update every time this property changes
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()

    let spacing = 5
    let starCount = 5

    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")

        for _ in 0..<starCount {
            let button = UIButton()

            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])

            // Make sure the image doesn't show an additional highlight during state change
            button.adjustsImageWhenHighlighted = false

            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)

            ratingButtons += [button]

            addSubview(button)
        }
    }

    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height
        let buttonSize = Int(frame.size.height)

        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)

        // Offset each button's irigin by the length of the button plus spacing
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }

        updateButtonSelectionStates()
    }

    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize * starCount) + (spacing * (starCount - 1))

        return CGSize(width: width, height: buttonSize)
    }

    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        // Returns an optional int because the button being searched for may not exist
        // ! force-unwraps the value since we know the button exists
        rating = ratingButtons.indexOf(button)! + 1

        updateButtonSelectionStates()
    }

    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected
            button.selected = index < rating
        }
    }
    
}
