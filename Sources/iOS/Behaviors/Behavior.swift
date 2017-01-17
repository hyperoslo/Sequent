import RxSwift
import Spots

public protocol Behavior {
  func extend(controller: SequentController)
}

public protocol PreAppearingBehavior {
  func behaviorWillAppear(in controller: SequentController)
}

public protocol PreDisappearingBehavior {
  func behaviorWillDisappear(in controller: SequentController)
}

public protocol PostAppearingBehavior {
  func behaviorDidAppear(in controller: SequentController)
}

public protocol PostDisappearingBehavior {
  func behaviorDidDisappear(in controller: SequentController)
}


