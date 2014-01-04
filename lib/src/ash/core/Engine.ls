package ash.core
{
	public delegate UpdateComplete() : void;

	/**
	 * The Engine class is the central point for creating and managing your game state. Add
	 * entities and systems to the engine, and fetch families of nodes from the engine.
	 */
	public class Engine
	{
		private var entityNames : Dictionary.<String, Entity>;
		private var entityList : EntityList;
		private var systemList : SystemList;
		private var families : Dictionary.<Type, IFamily>;
		
		/**
		 * Indicates if the engine is currently in its update loop.
		 */
		public var updating : Boolean;
		
		/**
		 * Dispatched when the update loop ends. If you want to add and remove systems from the
		 * engine it is usually best not to do so during the update loop. To avoid this you can
		 * listen for this signal and make the change when the signal is dispatched.
		 */
		public var updateComplete : UpdateComplete;
		
		/**
		 * The class used to manage node lists. In most cases the default class is sufficient
		 * but it is exposed here so advanced developers can choose to create and use a 
		 * different implementation.
		 * 
		 * The class must implement the Family interface.
		 */
		public var familyClass : Type = ComponentMatchingFamily;
		
		public function Engine()
		{
			entityList = new EntityList();
			entityNames = new Dictionary.<String, Entity>();
			systemList = new SystemList();
			families = new Dictionary.<Type, IFamily>();
			updateComplete = new UpdateComplete();
		}
		
		/**
		 * Add an entity to the engine.
		 * 
		 * @param entity The entity to add.
		 */
		public function addEntity( entity : Entity ) : void
		{
			Debug.assert( entityNames[ entity.name ] == null, "The entity name " + entity.name + " is already in use by another entity." );
			entityList.add( entity );
			entityNames[ entity.name ] = entity;
			entity.componentAdded += componentAdded;
			entity.componentRemoved += componentRemoved;
			entity.nameChanged += entityNameChanged;
			for each( var family : IFamily in families )
			{
				family.newEntity( entity );
			}
		}
		
		/**
		 * Remove an entity from the engine.
		 * 
		 * @param entity The entity to remove.
		 */
		public function removeEntity( entity : Entity ) : void
		{
			entity.componentAdded -= componentAdded;
			entity.componentRemoved -= componentRemoved;
			entity.nameChanged -= entityNameChanged;
			for each( var family : IFamily in families )
			{
				family.removeEntity( entity );
			}
			entityNames.deleteKey( entity.name );
			entityList.remove( entity );
		}
		
		private function entityNameChanged( entity : Entity, oldName : String ) : void
		{
			if( entityNames[ oldName ] == entity )
			{
				entityNames.deleteKey( oldName );
				entityNames[ entity.name ] = entity;
			}
		}
		
		/**
		 * Get an entity based n its name.
		 * 
		 * @param name The name of the entity
		 * @return The entity, or null if no entity with that name exists on the engine
		 */
		public function getEntityByName( name : String ) : Entity
		{
			return entityNames[ name ];
		}
		
		/**
		 * Remove all entities from the engine.
		 */
		public function removeAllEntities() : void
		{
			while( entityList.head )
			{
				removeEntity( entityList.head );
			}
		}
		
		/**
		 * Returns a vector containing all the entities in the engine.
		 */
		public function get entities() : Vector.<Entity>
		{
			var entitiesVector : Vector.<Entity> = new Vector.<Entity>();
			for( var entity : Entity = entityList.head; entity; entity = entity.next )
			{
				entitiesVector.push( entity );
			}
			return entitiesVector;
		}
		
		/**
		 * @private
		 */
		private function componentAdded( entity : Entity, componentClass : Type ) : void
		{
			for each( var family : IFamily in families )
			{
				family.componentAddedToEntity( entity, componentClass );
			}
		}
		
		/**
		 * @private
		 */
		private function componentRemoved( entity : Entity, componentClass : Type ) : void
		{
			for each( var family : IFamily in families )
			{
				family.componentRemovedFromEntity( entity, componentClass );
			}
		}
		
		/**
		 * Get a collection of nodes from the engine, based on the type of the node required.
		 * 
		 * <p>The engine will create the appropriate NodeList if it doesn't already exist and 
		 * will keep its contents up to date as entities are added to and removed from the
		 * engine.</p>
		 * 
		 * <p>If a NodeList is no longer required, release it with the releaseNodeList method.</p>
		 * 
		 * @param nodeClass The type of node required.
		 * @return A linked list of all nodes of this type from all entities in the engine.
		 */
		public function getNodeList( nodeClass : Type ) : NodeList
		{
			if( families[nodeClass] )
			{
				return IFamily( families[nodeClass] ).nodeList;
			}
			var family : IFamily = familyClass.getConstructor().invoke() as IFamily;
			var initMethodInfo : MethodInfo = familyClass.getMethodInfo("init");
			initMethodInfo.invoke( family, nodeClass, this );
			families[nodeClass] = family;
			for( var entity : Entity = entityList.head; entity; entity = entity.next )
			{
				family.newEntity( entity );
			}
			return family.nodeList;
		}
		
		/**
		 * If a NodeList is no longer required, this method will stop the engine updating
		 * the list and will release all references to the list within the framework
		 * classes, enabling it to be garbage collected.
		 * 
		 * <p>It is not essential to release a list, but releasing it will free
		 * up memory and processor resources.</p>
		 * 
		 * @param nodeClass The type of the node class if the list to be released.
		 */
		public function releaseNodeList( nodeClass : Type ) : void
		{
			if( families[nodeClass] )
			{
				families[nodeClass].cleanUp();
			}
			families.deleteKey( nodeClass );
		}
		
		/**
		 * Add a system to the engine, and set its priority for the order in which the
		 * systems are updated by the engine update loop.
		 * 
		 * <p>The priority dictates the order in which the systems are updated by the engine update 
		 * loop. Lower numbers for priority are updated first. i.e. a priority of 1 is 
		 * updated before a priority of 2.</p>
		 * 
		 * @param system The system to add to the engine.
		 * @param priority The priority for updating the systems during the engine loop. A 
		 * lower number means the system is updated sooner.
		 */
		public function addSystem( system : System, priority : int ) : void
		{
			system.priority = priority;
			system.addToEngine( this );
			systemList.add( system );
		}
		
		/**
		 * Get the system instance of a particular type from within the engine.
		 * 
		 * @param type The type of system
		 * @return The instance of the system type that is in the engine, or
		 * null if no systems of this type are in the engine.
		 */
		public function getSystem( type : Type ) : System
		{
			return systemList.getSystem( type );
		}
		
		/**
		 * Returns a vector containing all the systems in the engine.
		 */
		public function get systems() : Vector.<System>
		{
			var systemsVector : Vector.<System> = new Vector.<System>();
			for( var system : System = systemList.head; system; system = system.next )
			{
				systemsVector.push( system );
			}
			return systemsVector;
		}
		
		/**
		 * Remove a system from the engine.
		 * 
		 * @param system The system to remove from the engine.
		 */
		public function removeSystem( system : System ) : void
		{
			systemList.remove( system );
			system.removeFromEngine( this );
		}
		
		/**
		 * Remove all systems from the engine.
		 */
		public function removeAllSystems() : void
		{
			while( systemList.head )
			{
				removeSystem( systemList.head );
			}
		}

		/**
		 * Update the engine. This causes the engine update loop to run, calling update on all the
		 * systems in the engine.
		 * 
		 * <p>The package net.richardlord.ash.tick contains classes that can be used to provide
		 * a steady or variable tick that calls this update method.</p>
		 * 
		 * @time The duration, in seconds, of this update step.
		 */
		public function update( time : Number ) : void
		{
			updating = true;
			for( var system : System = systemList.head; system; system = system.next )
			{
				system.update( time );
			}
			updating = false;
			updateComplete();
		}
	}
}
