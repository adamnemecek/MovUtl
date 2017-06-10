import Cocoa

class ViewController: NSViewController {
    @IBOutlet var editView: EditView!
    @IBOutlet var timeLineView: NSView!
    @IBOutlet var propertyView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childViewControllers.forEach { vc in
            print(vc)
        }
    }
    
    func updateDocument(with doc: Document) {
        
    }
}

