import Sequent
import Spots

public struct SpotsConfigurator: Configurable {

  public func configure() {
    Spots.Controller.configure = {
      $0.backgroundColor = UIColor.clear
    }

    ListSpot.configure = { tableView in
      let inset: CGFloat = 15

      tableView.backgroundColor = UIColor.clear
      tableView.layoutMargins = UIEdgeInsets.zero
      tableView.tableFooterView = UIView(frame: CGRect.zero)
      tableView.separatorInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
      tableView.separatorStyle = .none
    }
  }
}
