import UIKit
import MuseSwift

class ViewController: UIViewController {

  @IBOutlet weak var scoreView: SingleLineScore!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func load(sender: AnyObject) {
    let tunePath = NSBundle.mainBundle().pathForResource("sample_tune", ofType: "txt")!
    let tuneString = try! String(contentsOfFile: tunePath, encoding: NSUTF8StringEncoding)
    let parser = ABCParser(string: tuneString)
    let tune = parser.parse().tune!
    let voice = tune.tuneBody.voices.first!
    let header = tune.tuneHeader.voiceHeaders.first!

    scoreView.loadVoice(tune.tuneHeader, voiceHeader: header, voice: voice)
  }
}

