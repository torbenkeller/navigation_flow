/// An interface which all arguments must implement when you want to pass them into the next page
abstract class FlowArguments {}

/// An empty class you can use when you don't want to pass any arguments into the next page.
class NoFlowArguments extends FlowArguments {}