import Sequent
import Malibu

public struct MalibuConfigurator: Configurable {

  public func configure() {
    Malibu.mode = .regular
    Malibu.logger.level = .verbose

    let networking = Networking(baseUrl: "http://jsonplaceholder.typicode.com/")

    networking.additionalHeaders = {
      ["Accept" : "application/json"]
    }

    Malibu.register("base", networking: networking)
  }
}
