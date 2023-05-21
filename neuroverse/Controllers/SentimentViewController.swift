//
//  SentimentViewController.swift
//  neuroverse
//
//  Created by Anuva Garg on 21/05/23.
//
import NaturalLanguage
import UIKit

class SentimentViewController: UIViewController {

    @IBOutlet weak var sentimentScoreTextView: UITextView!
    
    @IBOutlet weak var sentimentImageView: UIImageView!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentimentImageView.image = UIImage(named: "neutral")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextView.resignFirstResponder()
    }
    
    @IBAction func analyzeButtonTapped(_ sender: Any) {
        guard let text = inputTextView.text else {
                    return
                }
                
                let sentiment = analyzeSentiment(for: text)
                displaySentiment(sentiment)
    }
    func analyzeSentiment(for text: String) -> Double? {
            let tagger = NLTagger(tagSchemes: [.sentimentScore])
            tagger.string = text
            
            let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
            if let sentimentScore = sentiment?.rawValue {
                if let score = Double(sentimentScore) {
                    return score
                }
            }
            return nil
        }
    func displaySentiment(_ sentiment: Double?) {
            guard let sentiment = sentiment else {
                sentimentImageView.image = UIImage(named: "neutral")
                sentimentScoreTextView.text = "Unable to determine sentiment"
                return
            }
            
            if sentiment > 0 {
                sentimentImageView.image = UIImage(named: "positive")
                sentimentScoreTextView.text = "Sentiment score: \(sentiment)"
            } else if sentiment < 0 {
                sentimentImageView.image = UIImage(named: "negative")
                sentimentScoreTextView.text = "Sentiment score: \(sentiment)"
            } else {
                sentimentImageView.image = UIImage(named: "neutral")
                sentimentScoreTextView.text = "Sentiment score: \(sentiment)"
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
