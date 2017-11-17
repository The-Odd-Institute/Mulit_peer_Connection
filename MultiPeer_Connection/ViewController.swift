import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, UITableViewDataSource, UITableViewDelegate
{

    
    @IBOutlet weak var peersTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    
    
    
    var mySession: MCSession!
    var myBrowser: MCNearbyServiceBrowser!
    var myAdvertiser: MCNearbyServiceAdvertiser!
    
    
    
    
    var foundPeersArr = [MCPeerID]()
    var myPeer: MCPeerID!
    var curCorrespondingPeer: MCPeerID!
    
    
    var chatViewText: String = "";
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        myPeer = MCPeerID(displayName: UIDevice.current.name)
        mySession = MCSession(peer: myPeer)
        mySession.delegate = self
        
        
        
        myBrowser = MCNearbyServiceBrowser(peer: myPeer,
                                         serviceType: "nearbyServ")
        myBrowser.delegate = self
        
        
        myAdvertiser = MCNearbyServiceAdvertiser(peer: myPeer,
                                               discoveryInfo: nil,
                                               serviceType: "nearbyServ")
        myAdvertiser.delegate = self
        
        
        myBrowser.startBrowsingForPeers()
        myAdvertiser.startAdvertisingPeer()
    }
    
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return foundPeersArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "peerCell")!
        cell.textLabel?.text = foundPeersArr[indexPath.row].displayName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        myBrowser.invitePeer(foundPeersArr[indexPath.row],
                             to: mySession,
                             withContext: nil,
                             timeout: 20)

        curCorrespondingPeer = foundPeersArr[indexPath.row]
        chatViewText += "\nSelected \(foundPeersArr[indexPath.row].displayName)"
        chatTextView.text = chatViewText
    }
    
    
    
    
    


    // REQUIRED MCSESSION
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState)
    {
        if state == MCSessionState.connected
        {

        }
    }

    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID)
    {
        DispatchQueue.main.async
            {
            self.chatViewText += "\n Something came from \(peerID.displayName)"
            self.chatTextView.text = self.chatViewText
        }
    }

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) { }

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) { }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) { }


    // REQUIRED - SERVICE ADVERTISER
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        let alert = UIAlertController(title: "Invitation Recievd",
                                      message: "New invitation from \(peerID.displayName), what?",                                        preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Accept",
                                      style: UIAlertActionStyle.default,
                                      handler:
            { (alert) in
                invitationHandler(true, self.mySession)
        }))

        alert.addAction(UIAlertAction(title: "Deny",
                                      style: UIAlertActionStyle.cancel,
                                      handler:
            { (alert) in
                invitationHandler(false, self.mySession)
        }))

        self.present(alert,
                     animated: true,
                     completion: nil)

        chatViewText += "\n INVITATION RECEIVED FROM \(peerID.displayName)"
        chatTextView.text = chatViewText

        invitationHandler(true, mySession)
    }



    // REQUIRED - SERVICE BROWSER
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?)
    {
        foundPeersArr.append(peerID)

        chatViewText += "\nFOUND \(peerID.displayName)"
        chatTextView.text = chatViewText

        peersTableView.reloadData()
    }


    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID)
    {
        if let index = foundPeersArr.index(of:peerID)
        {
            foundPeersArr.remove(at: index)
            peersTableView.reloadData()

            chatViewText += "\nLOST \(peerID.displayName)"
            chatTextView.text = chatViewText
        }
    }
    
   
    
    
    @IBAction func sendAction(_ sender: Any)
    {
        if (curCorrespondingPeer == nil)
        {
            return
        }
        
        let toMessage = "Hello There!"
        if let data = toMessage.data(using: .utf8)
        {
            do
            {
                try mySession.send(data, toPeers:  [curCorrespondingPeer],
                                   with: .unreliable)
            }
            catch
            {
                print("[Error] \(error)")
            }
        }
    }
    
}
