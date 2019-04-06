//
//  CollectionViewItem.swift
//  SAO SDK
//
//  Created by Alessandro Mascolo on 12/29/18.
//  Copyright © 2018 Alessandro Mascolo. All rights reserved.
//

import Cocoa
import Contacts

class CollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var button: NSButton!
    
    @IBAction func buttonClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contact_click"), object: representedObject)
    }
    
    public override var representedObject: Any? {
        didSet {
            if let obj = representedObject as? CNContact {
                text = CNContactFormatter.string(from: obj, style: .fullName)!
                /* if let pict = obj.imageData {
                    image = NSImage(data: pict)
                } */
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    public var text : String = "" {
        didSet {
            button.title = text
        }
    }
    
    public var image : NSImage? = nil {
        didSet {
            imageView?.image = image
        }
    }
    
}
