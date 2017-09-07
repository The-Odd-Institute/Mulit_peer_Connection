import Foundation

class AppData: NSObject {
    static let sharedInstance = AppData();
    
    public var dataNode: DatabaseReference;
    
    public override init()
    {
        FirebaseApp.configure();
        dataNode = Database.database().reference().child("data");
    }
    
    func saveSomethingOnCloud (inpList: GroceryListStruct)
    {
        if (Auth.auth().currentUser == nil)
        {
            return
        }
        
        var uid: String = Auth.auth().currentUser.uid
        
        let toSaveVal: String = "ding ding";
        
        
        let toSaevDict: [String : Any] = ["name" : "Amir",
                                          "role" : "unknown",
                                          "place" : "north Van"];
        
        dataNode.child(uid).child("entry_String").setValue(toSaveVal);
        dataNode.child(uid).child("entry_Dict").setValue(toSaevDict);
    }
    
    
    func deleteSomethingOffTheCloud (inpList: GroceryListStruct)
    {
        if (Auth.auth().currentUser == nil)
        {
            return
        }
        
        let deleteNode : DatabaseReference = dataNode.child("entry_Dict");
        deleteNode.removeValue();
    }
    
    
    func changeValueOnCloud ()
    {
        if (Auth.auth().currentUser == nil)
        {
            return
        }
        
        var uid: String = Auth.auth().currentUser.uid

        let newSaveVal: String = "New Ding";
        dataNode.child(uid).child("entry_String").setValue(toSaveVal);

    }
    
    
    
    func registerMethod(inpName: String, inpEmail: String, inpPassword: String)
    {
        Auth.auth().createUser(withEmail: inpEmail, password: inpPassword)
        { (user, error) in
            if (error == nil)
            {
                let changeRequest = user?.createProfileChangeRequest();
                changeRequest?.displayName = inpName;
                
                changeRequest?.commitChanges(completion:
                    { (profError) in
                        if ( profError == nil)
                        {
                            let userDict : [String : String] = ["name" : inpName,
                                                                "email" : inpEmail,
                                                                "uid" : user!.uid];
                        }
                        else
                        {
                            
                        }
                });
            }
            else
            {
                
            }
        }
    }
    
    
    func loginMethod(inpEmail: String, inpPassword: String)
    {
        Auth.auth().signIn(withEmail: inpEmail, password: inpPassword)
        { (user, error) in
            if ( error == nil)
            {
                AppData.sharedInstance.setUser(inpName: user!.displayName!,
                                               inpEmail:  user!.email!,
                                               inpUid: user!.uid)
            }
        }
    }
    
    
    
    func logoutMethod ()
    {
        let firebaseAuth = Auth.auth();
        do
        {
            try firebaseAuth.signOut();
        }
        catch _ as NSError
        {
            
        }
    }   
}
