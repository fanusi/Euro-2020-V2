//
//  ViewController.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    public var dummy = 0
    
    var PronosA = [Pronostiek]()
    // PronosA contains real scores
    
    var PronosB = [[Pronostiek]]()
    // PronosB contains guesses of all players
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        if dummy == 0 {
            
            //Only parse on app loading
            fixtureParsing()
            dummy = 1
            
        }
        
    }
    
    func fixtureParsing () {
                
                //Populate PronosA from FootballAPI
            
                let headers = [
                    "x-rapidapi-key": "a08ffc63acmshbed8df93dae1449p15e553jsnb3532d9d0c9b",
                    "x-rapidapi-host": "api-football-v1.p.rapidapi.com"
                ]

                let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v2/fixtures/league/403?timezone=Europe%2FLondon")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
            
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    
                if error == nil && data != nil {
                    
                        
                let decoder = JSONDecoder()
                        
                do {
                            
                    
                        let g = 297
                        let niveau1 = try decoder.decode(api1.self, from: data!)
                        print(niveau1)
                        
                        for n in 0...g {

                            //print(niveau1.api.fixtures[n].fixture_id)
                            let newFixture = Pronostiek(context: self.context)
                            newFixture.fixture_ID = Int32(niveau1.api.fixtures[n].fixture_id)
                            newFixture.round = niveau1.api.fixtures[n].round
                            newFixture.home_Goals = Int16(niveau1.api.fixtures[n].goalsHomeTeam)
                            newFixture.away_Goals = Int16(niveau1.api.fixtures[n].goalsAwayTeam)
                            newFixture.home_Team = niveau1.api.fixtures[n].homeTeam.team_name
                            newFixture.away_Team = niveau1.api.fixtures[n].awayTeam.team_name
                            
                            
                            self.PronosA.append(newFixture)
                            //try self.context.savePronos2()
                        }
                    
                            
                    } catch {
                        
                        debugPrint(error)
                    }
                        
                }
                                
                })
                    
                dataTask.resume()

        }


}

extension UIViewController {
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
        default:
            break
        }
        
    }
    
}
