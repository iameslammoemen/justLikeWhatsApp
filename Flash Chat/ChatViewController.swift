//
//  ViewController.swift
//  Flash Chat
//


import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    // Declare instance variables here
 
    var   messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:'
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        //TODO: Register your MessageCell.xib file here:

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messgaeBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 3
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
        
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView () {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
        
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
          
            self.heightConstraint.constant = 315
            self.view.layoutIfNeeded()

            }
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
           
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()

        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    

    @IBAction func sendPressed(_ sender: AnyObject) {
        
    messageTextfield.endEditing(true)

        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            if error != nil {
                print(error!)
                
            }else{
                print("messageSavedSuccess")
            }
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
        }
    }
    
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages (){
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let sanpshotValue = snapshot.value as! Dictionary<String,String>
            let text = sanpshotValue["MessageBody"]!
            let sender = sanpshotValue["sender"]!
            
            let message = Message()
            message.messgaeBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try  Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)

        } catch  {
            print("SIGN OUT ERROR")
            
        }
    }
}
