package ash.fsm
{
	import ash.core.Engine;

	/**
	 * This is a state machine for the Engine. The state machine manages a set of states,
	 * each of which has a set of System providers. When the state machine changes the state, it removes
	 * Systems associated with the previous state and adds Systems associated with the new state.
	 */
	public class EngineStateMachine
	{
		/**
		 * The engine whose state machine this is
		 */
		public var engine : Engine;

		private var states : Dictionary.<String, EngineState>;
		private var currentState : EngineState;
		private var _currentStateName : String;

		/**
		 * Constructor. Creates an SystemStateMachine.
		 */
		public function EngineStateMachine( engine : Engine ) : void
		{
			this.engine = engine;
			states = new Dictionary.<String, EngineState>();
		}

		/**
		 * Add a state to this state machine.
		 *
		 * @param name The name of this state - used to identify it later in the changeState method call.
		 * @param state The state.
		 * @return This state machine, so methods can be chained.
		 */
		public function addState( name : String, state : EngineState ) : EngineStateMachine
		{
			states[ name ] = state;
			return this;
		}

		/**
		 * Create a new state in this state machine.
		 *
		 * @param name The name of the new state - used to identify it later in the changeState method call.
		 * @return The new EntityState object that is the state. This will need to be configured with
		 * the appropriate component providers.
		 */
		public function createState( name : String ) : EngineState
		{
			var state : EngineState = new EngineState();
			states[ name ] = state;
			return state;
		}

		/**
		 * Change to a new state. The Systems from the old state will be removed and the Systems
		 * for the new state will be added.
		 *
		 * @param name The name of the state to change to.
		 */
		public function changeState( name : String ) : void
		{
			var newState : EngineState = states[ name ];
			Debug.assert( newState != null, "Engine state " + name + " doesn't exist" );
			if ( newState == currentState )
			{
				newState = null;
				return;
			}
			var toAdd : Dictionary.<Object, ISystemProvider>;
			var provider : ISystemProvider;
			var id : Object;
			toAdd = new Dictionary.<Object, ISystemProvider>();
			for each (provider in newState.providers)
			{
				id = provider.identifier;
				toAdd[ id ] = provider;
			}
			if ( currentState )
			{
				for each (provider in currentState.providers)
				{
					id = provider.identifier;
					var other : ISystemProvider = toAdd[ id ];

					if ( other )
					{
						toAdd.deleteKey( id );
					}
					else
					{
						engine.removeSystem( provider.getSystem() );
					}
				}
			}
			for each(provider in toAdd)
			{
				engine.addSystem( provider.getSystem(), provider.priority );
			}
			currentState = newState;
			_currentStateName = name;
		}

		/**
		 * Retrieve the name of the current state
		 */
		public function get currentStateName() : String
		{
			return _currentStateName;
		}
	}
}
