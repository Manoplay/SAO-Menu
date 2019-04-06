//
//  AppDelegate.swift
//  SAO SDK
//
//  Created by Alessandro Mascolo on 12/11/18.
//  Copyright © 2018 Alessandro Mascolo. All rights reserved.
//

import Contacts
import Cocoa

class ContactsDataSource: NSObject, NSCollectionViewDataSource {
    
    var values : [CNContact]? = nil
    
    override init() {
        let store = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var result : [CNContact] = []
        /* do {
        let containers = try store.containers(matching: nil)
        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                result.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        }catch{
            print("Cannot get contacts")
        }
        */
        let req = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        try! store.enumerateContacts(with: req) {
            contact, stop in
            result.append(contact)
        }
        values = result
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return values!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard let cvitem = item as? CollectionViewItem else { return item }
        cvitem.representedObject = values?[indexPath.item]
        /* if let pict = values?[indexPath.item].imageData {
            print("Set image \(pict)")
            cvitem.image = NSImage(data: pict)
        } */
        return cvitem
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var msgBoxText: NSTextField!
    @IBOutlet weak var msgBoxTitle: NSTextField!
    @IBOutlet weak var msgBoxWindow: NSWindow!
    @IBOutlet weak var singleContactWindow: NSWindow!
    @IBOutlet weak var contactName: NSTextField!
    @IBOutlet weak var personalButton: NSButton!
    @IBOutlet weak var healthPoint: NSTextField!
    @IBOutlet weak var contactsList: NSCollectionView!
    @IBOutlet weak var friendsButton: NSButton!
    @IBOutlet weak var messagesButton: NSButton!
    @IBOutlet weak var contactPicture: NSImageView!
    @IBOutlet weak var phoneNumberField: NSTextField!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var contactsWindow: NSWindow!
    @IBOutlet weak var contactNameField: NSTextField!
    @IBOutlet weak var personalWindow: NSWindow!
    @IBOutlet weak var guildWindow: NSWindow!

    @IBAction func swipePersonal(_ sender: Any) {
        print("Gesture recognized")
    }
    
    @IBAction func guildButton(_ sender: Any) {
        msgBox(title: "Error", text: "You do not belong to any guild.")
    }
    
    func msgBox(title: String, text : String) {
        msgBoxWindow.makeKeyAndOrderFront(nil)
        msgBoxWindow.alphaValue = 0
        msgBoxTitle.stringValue = title
        msgBoxText.stringValue = text
        let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! / 2 - 470 / 2, y: (NSScreen.main()?.frame.maxY)! / 2, width: 470, height: 1)
        msgBoxWindow.setFrame(initialize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            msgBoxWindow.animator().alphaValue = 1.0
            msgBoxWindow.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! / 2 - 470 / 2, y: (NSScreen.main()?.frame.maxY)! / 2 - 120, width: 470, height: 240), display: true)
        }, completionHandler: {print("Done")})
    }
    
    @IBAction func msgBoxDismiss(_ sender: Any) {
        msgBoxWindow.makeKeyAndOrderFront(nil)
        msgBoxWindow.alphaValue = 1
        let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! / 2 - 470 / 2, y: (NSScreen.main()?.frame.maxY)! / 2, width: 470, height: 1)
        let synchronize = NSRect(x: (NSScreen.main()?.frame.maxX)! / 2 - 470 / 2, y: (NSScreen.main()?.frame.maxY)! / 2 - 120, width: 470, height: 240)
        msgBoxWindow.setFrame(synchronize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            msgBoxWindow.animator().alphaValue = 0
            msgBoxWindow.animator().setFrame(initialize, display: true)
        }, completionHandler: {self.msgBoxWindow.orderOut(nil)})
    }
    
    func contactViewOnClick(not: Notification) {
        if let contact = not.object as? CNContact {
            singleContactWindow.makeKeyAndOrderFront(nil)
            contactNameField.stringValue = CNContactFormatter.string(from: contact, style: .fullName)!
            if let pict = contact.thumbnailImageData {
                contactPicture.image = NSImage(data: pict)!
            }
            phoneNumberField.stringValue = "Phone number: \(contact.phoneNumbers.count > 0 ? contact.phoneNumbers.first!.value.stringValue : "none")"
            emailField.stringValue = "Email: \(contact.emailAddresses.count > 0 ? contact.emailAddresses.first!.value : "none")"
            singleContactWindow.alphaValue = 0
            let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! - 450 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 10, height: 10)
            singleContactWindow.setFrame(initialize, display: true)
            NSAnimationContext.runAnimationGroup({
                context in
                singleContactWindow.animator().alphaValue = 1.0
                singleContactWindow.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! - 419 - intercetta - 150, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 369, height: 416), display: true)
            }, completionHandler: {print("Done")})
        }
    }
    
    func loseFocus() {
        personalWindow.orderOut(self)
        guildWindow.orderOut(self)
        singleContactWindow.orderOut(self)
        contactsWindow.orderOut(self)
        personalButton.state = NSOffState
        friendsButton.state = NSOffState
        messagesButton.state = NSOffState
    }
    
    let intercetta = CGFloat(98)

    @IBAction func showContactsWindow(_ sender: Any) {
        loseFocus()
        contactsList.reloadData()
        friendsButton.state = NSOnState
        contactsWindow.makeKeyAndOrderFront(nil)
        contactsWindow.alphaValue = 0
        let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! - 159 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 10, height: 10)
        contactsWindow.setFrame(initialize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            contactsWindow.animator().alphaValue = 1.0
            contactsWindow.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! - 200 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 150, height: 362), display: true)
        }, completionHandler: {print("Done")})
    }
    
    @IBAction func showPersonalWindow(_ sender: Any) {
        loseFocus()
        do {
            let dict = try FileManager.default.attributesOfFileSystem(forPath: "/")
            let freeSpace : Int = dict[FileAttributeKey.systemFreeSize] as! Int
            let diskSpace : Int = dict[FileAttributeKey.systemSize] as! Int
            healthPoint.stringValue = "HP: \(freeSpace/1000/1000/1000)/\(diskSpace/1000/1000/1000)"
        }catch{
            healthPoint.stringValue = "HP: not available"
        }
        personalButton.state = NSOnState
        personalWindow.makeKeyAndOrderFront(nil)
        personalWindow.alphaValue = 0
        let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! - 300 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 10, height: 10)
        personalWindow.setFrame(initialize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            personalWindow.animator().alphaValue = 1.0
            personalWindow.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! - 419 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 369, height: 416), display: true)
        }, completionHandler: {print("Done")})
        
        // GUILD MENU
        guildWindow.makeKeyAndOrderFront(nil)
        guildWindow.alphaValue = 0
        let reinitialize = NSRect(x: (NSScreen.main()?.frame.maxX)! - 98, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 10, height: 10)
        guildWindow.setFrame(reinitialize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            guildWindow.animator().alphaValue = 1.0
            guildWindow.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! - 98, y: (NSScreen.main()?.frame.maxY)! / 2 - 50, width: 98, height: 143), display: true)
        }, completionHandler: {print("Done")})
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "contact_click"), object: nil, queue: nil, using: contactViewOnClick)
        contactsList.register(CollectionViewItem.self, forItemWithIdentifier: "CollectionViewItem")
        name.stringValue = NSUserName()
        window.backgroundColor = NSColor.clear
        guildWindow.backgroundColor = NSColor.clear
        personalWindow.backgroundColor = NSColor.white
        window.alphaValue = 0
        let initialize = NSRect(x: (NSScreen.main()?.frame.maxX)! - 50 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 25, width: 50, height: 50)
        window.setFrame(initialize, display: true)
        NSAnimationContext.runAnimationGroup({
            context in
            window.animator().alphaValue = 1.0
            window.animator().setFrame(NSRect(x: (NSScreen.main()?.frame.maxX)! - 50 - intercetta, y: (NSScreen.main()?.frame.maxY)! / 2 - 75, width: 50, height: 150), display: true)
        }, completionHandler: {print("Done")})
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
