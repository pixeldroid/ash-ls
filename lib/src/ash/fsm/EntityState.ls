package ash.fsm
{
	import system.reflection.Type;

	/**
	 * Represents a state for an EntityStateMachine. The state contains any number of ComponentProviders which
	 * are used to add components to the entity when this state is entered.
	 */
	public class EntityState
	{
		/**
		 * @private
		 */
		public var providers : Dictionary.<Type, IComponentProvider> = new Dictionary.<Type, IComponentProvider>();

		/**
		 * Add a new ComponentMapping to this state. The mapping is a utility class that is used to
		 * map a component type to the provider that provides the component.
		 * 
		 * @param type The type of component to be mapped
		 * @return The component mapping to use when setting the provider for the component
		 */
		public function add( type : Type ) : StateComponentMapping
		{
			return new StateComponentMapping( this, type );
		}
		
		/**
		 * Get the ComponentProvider for a particular component type.
		 * 
		 * @param type The type of component to get the provider for
		 * @return The ComponentProvider
		 */
		public function getProvider( type : Type ) : IComponentProvider
		{
			return providers[ type ];
		}
		
		/**
		 * To determine whether this state has a provider for a specific component type.
		 * 
		 * @param type The type of component to look for a provider for
		 * @return true if there is a provider for the given type, false otherwise
		 */
		public function has( type : Type ) : Boolean
		{
			return providers[ type ] != null;
		}
	}
}
