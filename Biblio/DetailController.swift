//
//  DetailController.swift
//  Biblio
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    var passedValue: JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedValue)
        bookTitle.text = passedValue["volumeInfo"]["title"].stringValue
        subTitle.text = passedValue["volumeInfo"]["subtitle"].stringValue
        publishDate.text = passedValue["volumeInfo"]["publishedDate"].stringValue
        bookDescription.text = passedValue["volumeInfo"]["description"].stringValue
        let authors = passedValue["volumeInfo"]["authors"].array
        var authorText: String = ""
        for auth in authors! {
            authorText += (auth.string! + "\n")
        }
        authorText.removeLast(2)
        author.text = authorText
        var url: String = (passedValue["volumeInfo"]["imageLinks"]["smallThumbnail"].string != nil) ? passedValue["volumeInfo"]["imageLinks"]["smallThumbnail"].string! :  ""
        url = url.replacingOccurrences(of: "http", with: "https")
        let imageUrl:URL = URL(string: url != "" ? url : "https://http.cat/404")!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.cover.image = image
            }
        }
    }
    
}
