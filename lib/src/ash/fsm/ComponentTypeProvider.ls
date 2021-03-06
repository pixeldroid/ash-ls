package ash.fsm
{
	import system.reflection.Type;

	/**
	 * This component provider always returns a new instance of a component. An instance
	 * is created when requested and is of the type passed in to the constructor.
	 */
	public class ComponentTypeProvider implements IComponentProvider
	{
		private var componentType : Type;
		
		/**
		 * Constructor
		 * 
		 * @param type The type of the instances to be created
		 */
		public function ComponentTypeProvider( type : Type )
		{
			this.componentType = type;
		}
		
		/**
		 * Used to request a component from this provider
		 * 
		 * @return A new instance of the type provided in the constructor
		 */
		public function getComponent() : Object
		{
			return componentType.getConstructor().invoke();
		}
		
		/**
		 * Used to compare this provider with others. Any ComponentTypeProvider that returns
		 * the same type will be regarded as equivalent.
		 * 
		 * @return The type of the instances created
		 */
		public function get identifier() : Object
		{
			return componentType;
		}
	}
}
