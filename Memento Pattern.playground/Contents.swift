import Foundation

//MARK: -Originator
//Object to be saved or restore.
public class Game:Codable{
    public class State:Codable{
        public var attemptsRemainig :Int = 3
        public var level :Int = 1
        public var score : Int = 0
    }
    public var state = State()
    
    public func rackUpMassivePoints(){
        state.score += 9002
    }
    
    public func monstersEatPlayer(){
        state.attemptsRemainig -= 1
    }
}

//MARK: - Memento
//Represent a stored state.
typealias GameMemento = Data

//MARK: - CareTaker
//Request save from the originator and receives a memento in response.

public class GameSystem{
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    
    public func save( _ game:Game , title :String) throws {
        let data = try encoder.encode(game)
        userDefaults.set(data, forKey: title)
    }
    
    public func laod(title : String) throws -> Game{
        guard let data = userDefaults.data(forKey: title), let game = try? decoder.decode(Game.self, from: data) else {
            throw Error.gameNotFound
        }
        return game
    }
    
    public enum Error:String , Swift.Error{
        case gameNotFound
    }
}

//Examples

//my Game :)ß
let aymanGame = Game()
aymanGame.rackUpMassivePoints()
aymanGame.monstersEatPlayer()

//Save New game data
let gameSystem = GameSystem()
try gameSystem.save(aymanGame, title: "ayman game")

//new game
var newGame = Game()
print("new game score \(newGame.state.score)")

//load saved data
try gameSystem.laod(title: "ayman game")
print("ayman saved data score \(aymanGame.state.score)")
