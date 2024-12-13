import UIKit

class ViewController: UIViewController {

    var words = ["buddha", "gita", "arjuna", "krishna", "pandavas", "kauravas", "hastinapura", "plato", "socrates", "aristotle", "confucius", "pyramid", "fire", "sun", "eagle", "isis", "horus", "gilgamesh", "zeus ", "hera", "aphrodite", "coliseum", "constellation", "parthenon", "star", "moon", "toga", "universe", "cosmos", "theos", "tibet", "monastery", "yoga", "singing bowl", "incense", "myth", "nile river", "virtues", "beauty", "goodness", "justice", "generocity", "temperance", "dignity", "discipline", "perseverance", "mastery", "disciple", "investigation", "service", "recipe", "devotion", "karma", "dharma", "emotions", "lord of the rings", "star wars", "the matrix", "prana", "stuhla", "linga", "kama manas", "monkey mind", "mandala", "iching", "soul", "nous", "psyche", "soma", "demeter", "persephanie", "underworld", "epictetus", "seneca", "meditations", "zeno", "marcus aurelius", "unity ", "paradox", "duality", "attention", "memory", "consciousness", "avatars", "bodhisattva", "manu", "mahachohan", "blavatsky", "voice of the silence", "library of alexandria", "hall of learning", "hall of ignorance", "hypatia", "animals", "mushrooms", "mineral", "reincarnation", "ceiling", "chariot", "labour", "theseus", "minotaur", "acropolis", "parthenon", "the academy", "pythagoras", "astrology", "numerology", "psychology", "biology", "arithmetic", "gymnastics", "eudemonia", "machiavelli", "middle way", "8fold path", "4 noble truths", "philosophy", "history", "evolution", "sociopolitics", "ethics", "cycles", "space", "time", "architecture", "rome", "stoicism", "greece ", "trojan war", "olive tree", "culture", "volunteering", "trident", "civilization", "idealists", "tribe", "ceremony", "ritual", "family", "fraternity ", "prometheus", "zeus ", "titans", "Trojan horse", "king arthur", "holy grail", "excalibur", "renaissance", "alchemy", "lead", "gold", "bronze", "silver", "aristocracy", "democracy", "tyranny"]
    
    var currentIndex = 0
    var wordLabel: UILabel!
    var timerLabel: UILabel!
    var roundTimer: Timer?
    var wordTimer: Timer?
    var roundDuration: TimeInterval = 18  // # of seconds for each ROUND
    var wordDuration: TimeInterval = 3    // #of seconds for each WORD
    var remainingTime: TimeInterval = 0
    var isGameOver = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI
        setupUI()

        // Start round and timers
        startRound()

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextWord))
        self.view.addGestureRecognizer(tapGesture)
    }

    // Setup UI components
    func setupUI() {
        // Word label
        wordLabel = UILabel()
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 100)
        wordLabel.text = words[currentIndex]
        wordLabel.adjustsFontSizeToFitWidth = true
        wordLabel.minimumScaleFactor = 0.5
        wordLabel.numberOfLines = 0
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(wordLabel)

        // Center the word label horizontally and vertically
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            wordLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8)
        ])

        // Timer label
        timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 36)
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.minimumScaleFactor = 0.5
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timerLabel)

        // Center the timer label horizontally at the bottom
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            timerLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8)
        ])
    }

    // Start a new round
    func startRound() {
        isGameOver = false
        updateWordLabel()
        startWordTimer()
        startRoundTimer()
    }

    // Update word label
    func updateWordLabel() {
        if currentIndex < words.count {
            wordLabel.text = words[currentIndex]
        } else {
            endRound()
        }
    }

    // Start timer for each word
    func startWordTimer() {
        wordTimer = Timer.scheduledTimer(timeInterval: wordDuration, target: self, selector: #selector(nextWord), userInfo: nil, repeats: true)
    }

    // Go to the next word
    @objc func nextWord() {
        currentIndex += 1
        if currentIndex < words.count {
            updateWordLabel()
        } else {
            wordTimer?.invalidate()
            endRound()
        }
    }

    // Start round timer
    func startRoundTimer() {
        remainingTime = roundDuration
        roundTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRoundTimer), userInfo: nil, repeats: true)
    }

    // Update the round timer every second
    @objc func updateRoundTimer() {
        remainingTime -= 1
        timerLabel.text = "Time Left: \(Int(remainingTime))s"

        if remainingTime <= 0 {
            endRound()
        }
    }

    // End the round
    func endRound() {
        roundTimer?.invalidate()
        wordTimer?.invalidate()
        isGameOver = true

        // Show game over and offer to start a new round
        showGameOverAlert()
    }

    // Show game over alert with an option to start a new round
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Round Over", message: "Would you like to start a new round with the next word?", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Start Next Round", style: .default) { _ in
            // Start a new round without resetting the currentIndex
            self.startRound()
        }
        alert.addAction(restartAction)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
