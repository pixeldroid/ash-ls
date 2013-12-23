package ash.fsm
{
	import system.reflection.Type;

	/**
	 * This component provider always returns the same instance of the component. The instance
	 * is created when first required and is of the type passed in to the constructor.
	 */
	public class ComponentSingletonProvider implements IComponentProvider
	{
		private var componentType : Type;
		private var instance : Object;
		
		/**
		 * Constructor
		 * 
		 * @param type The type of the single instance
		 */
		public function ComponentSingletonProvider( type : Type )
		{
			this.componentType = type;
		}
		
		/**
		 * Used to request a component from this provider
		 * 
		 * @return The single instance
		 */
		public function getComponent() : Object
		{
			if( !instance )
			{
				instance = componentType.getConstructor().invoke();
			}
			return instance;
		}
		
		/**
		 * Used to compare this provider with others. Any provider that returns the same single
		 * instance will be regarded as equivalent.
		 * 
		 * @return The single instance
		 */
		public function get identifier() : Object
		{
			return getComponent();
		}
	}
}
