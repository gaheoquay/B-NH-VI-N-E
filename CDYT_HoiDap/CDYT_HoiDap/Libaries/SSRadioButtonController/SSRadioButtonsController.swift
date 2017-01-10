//
//  RadioButtonsController.swift
//  TestApp
//
//  Created by Al Shamas Tufail on 24/03/2015.
//  Copyright (c) 2015 Al Shamas Tufail. All rights reserved.
//

import Foundation
import UIKit

/// RadioButtonControllerDelegate. Delegate optionally implements didSelectButton that receives selected button.
@objc protocol SSRadioButtonControllerDelegate {
    /**
        This function is called when a button is selected. If 'shouldLetDeSelect' is true, and a button is deselected, this function
    is called with a nil.
    
    */
    @objc optional func didSelectButton(aButton: UIButton?)
}

class SSRadioButtonsController : NSObject
{
    private var buttonsArray = [UIButton]()
    private weak var currentSelectedButton:UIButton? = nil
    weak var delegate : SSRadioButtonControllerDelegate? = nil
    /**
        Set whether a selected radio button can be deselected or not. Default value is false.
    */
    var shouldLetDeSelect = false
    /**
        Variadic parameter init that accepts UIButtons.

        - parameter buttons: Buttons that should behave as Radio Buttons
    */
    init(buttons: UIButton...) {
        super.init()
        for aButton in buttons {
            aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(sender:)), for: UIControlEvents.touchUpInside)
        }
        self.buttonsArray = buttons
    }
    /**
        Add a UIButton to Controller

        - parameter button: Add the button to controller.
    */
    func addButton(aButton: UIButton) {
        buttonsArray.append(aButton)
        aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(sender:)), for: UIControlEvents.touchUpInside)
    }
    /** 
        Remove a UIButton from controller.

        - parameter button: Button to be removed from controller.
    */
    func removeButton(aButton: UIButton) {
        let index = 0
        var iteratingButton: UIButton? = nil
//        for( ; iteration<buttonsArray.count; iteration += 1) {
            for (index) in 0...buttonsArray.count{
            iteratingButton = buttonsArray[index]
            if(iteratingButton == aButton) {
                break
            } else {
                iteratingButton = nil
            }
        }
        if(iteratingButton != nil) {
            buttonsArray.remove(at: index)
            iteratingButton!.removeTarget(self, action: #selector(SSRadioButtonsController.pressed(sender:)), for: UIControlEvents.touchUpInside)
            if currentSelectedButton == iteratingButton {
                currentSelectedButton = nil
            }
        }
    }
    /**
        Set an array of UIButons to behave as controller.
        
        - parameter buttonArray: Array of buttons
    */
    func setButtonsArray(aButtonsArray: [UIButton]) {
        for aButton in aButtonsArray {
            aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(sender:)), for: UIControlEvents.touchUpInside)
        }
        buttonsArray = aButtonsArray
    }

    func pressed(sender: UIButton) {
        if(sender.isSelected) {
            if shouldLetDeSelect {
                sender.isSelected = false
                currentSelectedButton = nil
            }
        } else {
            for aButton in buttonsArray {
                aButton.isSelected = false
            }
            sender.isSelected = true
            currentSelectedButton = sender
        }
        delegate?.didSelectButton?(aButton: currentSelectedButton)
    }
    /**
        Get the currently selected button.
    
        - returns: Currenlty selected button.
    */
    func selectedButton() -> UIButton? {
        return currentSelectedButton
    }
}
