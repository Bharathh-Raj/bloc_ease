## 0.1.0
- FourStates declaration
- BlocEaseStateWidgetsProvider widget - Used to configure default state widgets
- FourStateBuilder widget - Used instead of BlocBuilder which gives typesafe success object to build UI
- FourStateListener widget - Used instead of BlocListener which gives typesafe success object
- FourStateConsumer widget - Used instead of BlocConsumer
- Context extensions
  - `initialStateWidget` - Gives default initial state widget
  - `loadingStateWidget` - Gives default loading state widget
  - `failedStateWidget` - Gives default failed state widget
- Included Intellj and VSCode extensions to create cubit/bloc

## 0.2.0
- map function for state
- mayBeMap function for state

## 0.2.1
- feat: isLoading getter in FourState

## 0.3.0
- feat: when and maybeWhen function for state
- retryCallback in failed state