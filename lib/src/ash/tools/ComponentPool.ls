package ash.tools
{
	import system.reflection.Type;

	/**
	 * An object pool for re-using components. This is not integrated in to Ash but is used dierectly by 
	 * the developer. It expects components to not require any parameters in their constructor.
	 * 
	 * <p>Fetch an object from the pool with</p>
	 * 
	 * <p>ComponentPool.get( ComponentClass );</p>
	 * 
	 * <p>If the pool contains an object of the required type, it will be returned. If it does not, a new object
	 * will be created and returned.</p>
	 * 
	 * <p>The object returned may have properties set on it from the time it was previously used, so all properties
	 * should be reset in the object once it is received.</p>
	 * 
	 * <p>Add an object to the pool with</p>
	 * 
	 * <p>ComponentPool.dispose( component );</p>
	 * 
	 * <p>You will usually want to do this when removing a component from an entity. The remove method on the entity
	 * returns the component that was removed, so this can be done in one line of code like this</p>
	 * 
	 * <p>ComponentPool.dispose( entity.remove( component ) );</p>
	 */
	public class ComponentPool
	{
		private static var pools : Dictionary.<Type, Vector.<Object>> = new Dictionary.<Type, Vector.<Object>>();

		private static function getPool( componentClass : Type ) : Vector.<Object>
		{
			return pools[componentClass] != null ? pools[componentClass] : pools[componentClass] = new Vector.<Object>();
		}

		/**
		 * Get an object from the pool.
		 * 
		 * @param componentClass The type of component wanted.
		 * @return The component.
		 */
		public static function getComponent( componentClass:Type ):Object
		{
			var pool:Vector.<Object> = getPool( componentClass );
			if( pool.length > 0 )
			{
				return pool.pop();
			}
			else
			{
				return componentClass.getConstructor().invoke();
			}
		}

		/**
		 * Return an object to the pool for reuse.
		 * 
		 * @param component The component to return to the pool.
		 */
		public static function dispose( component : Object ) : void
		{
			if( component )
			{
				var type : Type = component.getType();
				var pool:Vector.<Object> = getPool( type );
				pool.pushSingle( component );
			}
		}
		
		/**
		 * Dispose of all pooled resources, freeing them for garbage collection.
		 */
		public static function empty() : void
		{
			pools = new Dictionary.<Type, Vector.<Object>>();
		}
	}
}
