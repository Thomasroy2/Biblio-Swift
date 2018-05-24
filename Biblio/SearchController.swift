//
//  SearchController.swift
//  Biblio
//
//  Created by Developer on 27/04/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var books: JSON = JSON.null
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let test = searchBar.text
        self.search(forName: (searchBar.text != "" ? searchBar.text! : "''").replacingOccurrences(of: " ", with: "+"))
    }
    
    func search(forName: String) {
        let googleBooksEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=" + forName
        guard let url = URL(string: googleBooksEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling API")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let json = JSON(responseData)
            self.books = json["items"]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;
    }
    
    var valueToPass:JSON!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        // let indexPath = tableView.indexPathForSelectedRow!
        
        valueToPass = self.books[indexPath.row]
        performSegue(withIdentifier: "gotoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "gotoDetail") {
            let viewController = segue.destination as! DetailController
            
            viewController.passedValue = valueToPass
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchBookCell", for: indexPath) as! bookTableViewCell
        cell.bookTitle?.text = self.books[indexPath.row]["volumeInfo"]["title"].string
        var url: String = (self.books[indexPath.row]["volumeInfo"]["imageLinks"]["smallThumbnail"].string != nil) ? self.books[indexPath.row]["volumeInfo"]["imageLinks"]["smallThumbnail"].string! :  ""
        url = url.replacingOccurrences(of: "http", with: "https")
        let imageUrl:URL = URL(string: url != "" ? url : "https://http.cat/404")!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
 
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.thumbnail.image = image
            }
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
class bookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
}

