package ash.fsm
{

	/**
	 * This component provider always returns the same instance of the component. The instance
	 * is passed to the provider at initialisation.
	 */
	public class ComponentInstanceProvider implements IComponentProvider
	{
		private var instance : Object;
		
		/**
		 * Constructor
		 * 
		 * @param instance The instance to return whenever a component is requested.
		 */
		public function ComponentInstanceProvider( instance : Object )
		{
			this.instance = instance;
		}
		
		/**
		 * Used to request a component from this provider
		 * 
		 * @return The instance
		 */
		public function getComponent() : Object
		{
			return instance;
		}
		
		/**
		 * Used to compare this provider with others. Any provider that returns the same component
		 * instance will be regarded as equivalent.
		 * 
		 * @return The instance
		 */
		public function get identifier() : Object
		{
			return instance;
		}
	}
}
