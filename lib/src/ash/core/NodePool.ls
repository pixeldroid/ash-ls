package ash.core
{
	import system.reflection.Type;

	/**
	 * This internal class maintains a pool of deleted nodes for reuse by the framework. This reduces the overhead
	 * from object creation and garbage collection.
	 * 
	 * Because nodes may be deleted from a NodeList while in use, by deleting Nodes from a NodeList
	 * while iterating through the NodeList, the pool also maintains a cache of nodes that are added to the pool
	 * but should not be reused yet. They are then released into the pool by calling the releaseCache method.
	 */
	public class NodePool
	{
		private var tail : Node;
		private var nodeClass : Type;
		private var cacheTail : Node;
		private var components : Dictionary.<Type, String>;

		/**
		 * Creates a pool for the given node class.
		 */
		public function NodePool( nodeClass : Type, components : Dictionary.<Type, String> )
		{
			this.nodeClass = nodeClass;
			this.components = components;
		}

		/**
		 * Fetches a node from the pool.
		 */
		public function getNode() : Node
		{
			if ( tail )
			{
				var node : Node = tail;
				tail = tail.previous;
				node.previous = null;
				return node;
			}
			else
			{
				return nodeClass.getConstructor().invoke() as Node;
			}
		}

		/**
		 * Adds a node to the pool.
		 */
		public function dispose( node : Node ) : void
		{
			var nodeClass : Type = node.getType();
			for each( var componentName : String in components )
			{
				var fieldInfo : FieldInfo = nodeClass.getFieldInfoByName( componentName );
				fieldInfo.setValue(node, null);
			}
			node.entity = null;
			
			node.next = null;
			node.previous = tail;
			tail = node;
		}
		
		/**
		 * Adds a node to the cache
		 */
		public function cache( node : Node ) : void
		{
			node.previous = cacheTail;
			cacheTail = node;
		}
		
		/**
		 * Releases all nodes from the cache into the pool
		 */
		public function releaseCache() : void
		{
			while( cacheTail )
			{
				var node : Node = cacheTail;
				cacheTail = node.previous;
				dispose( node );
			}
		}
	}
}
