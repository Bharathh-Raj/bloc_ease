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

## 0.3.1
- feat: BlocEaseMultiStateListener widget 
  - Used to listen to states of multiple cubits that emits BlocEaseState.
  - Even used to extract specific states of different cubits by using BlocEaseMultiStateListener<SucceedState>. eg: List<SucceedState> for cubits that emits FourStates.

## 1.0.0
- Breaking: FourStates -> BlocEaseState
  - Make sure to update the code snippets
- feat: CacheExBlocEaseStateMixin
  - Caches the last loading, succeed and failed state.
- feat: message field in LoadingState
- feat: BlocEaseMultiStateBuilder
  - Used to combine multiple states that emits BlocEaseState

## 1.0.1
- Breaking: BlocEaseStateCacheMixin -> CacheExBlocEaseStateMixin
- feat: exSucceedObject in BlocEaseState
  - Used to extract the succeed object from the state

## 1.0.4
- Docs update

## 1.1.0
- feat: state parameter support in BlocEaseStateWidgetsProvider
  - Useful for state type checks. 