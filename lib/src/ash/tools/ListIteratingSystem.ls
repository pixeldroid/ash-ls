package ash.tools
{
	import system.reflection.Type;

	import ash.core.Engine;
	import ash.core.Node;
	import ash.core.NodeList;
	import ash.core.System;

	/**
	 * A useful class for systems which simply iterate over a set of nodes, performing the same action on each node. This
	 * class removes the need for a lot of boilerplate code in such systems. Extend this class and pass the node type and
	 * a node update method into the constructor. The node update method will be called once per node on the update cycle
	 * with the node instance and the frame time as parameters. e.g.
	 * 
	 * <code>package
	 * {
	 *   public class MySystem extends ListIteratingSystem
	 *   {
	 *     public function MySystem()
	 *     {
	 *       super( MyNode, updateNode );
	 *     }
	 *     
	 *     private function updateNode( node : MyNode, time : Number ) : void
	 *     {
	 *       // process the node here
	 *     }
	 *   }
	 * }</code>
	 */
	public class ListIteratingSystem extends System
	{
		protected var nodeList : NodeList;
		protected var nodeClass : Type;
		protected var nodeUpdateFunction : Function;
		protected var nodeAddedFunction : Function;
		protected var nodeRemovedFunction : Function;
		
		public function ListIteratingSystem( nodeClass : Type, nodeUpdateFunction : Function, nodeAddedFunction : Function = null, nodeRemovedFunction : Function = null )
		{
			this.nodeClass = nodeClass;
			this.nodeUpdateFunction = nodeUpdateFunction;
			this.nodeAddedFunction = nodeAddedFunction;
			this.nodeRemovedFunction = nodeRemovedFunction;
		}
		
		override public function addToEngine( engine : Engine ) : void
		{
			nodeList = engine.getNodeList( nodeClass );
			if( nodeAddedFunction != null )
			{
				for( var node : Node = nodeList.head; node; node = node.next )
				{
					nodeAddedFunction( node );
				}
				nodeList.nodeAdded += onNodeAdded;
			}
			if( nodeRemovedFunction != null )
			{
				nodeList.nodeRemoved += onNodeRemoved;
			}
		}
		
		override public function removeFromEngine( engine : Engine ) : void
		{
			if( nodeAddedFunction != null )
			{
				nodeList.nodeAdded += onNodeAdded;
			}
			if( nodeRemovedFunction != null )
			{
				nodeList.nodeRemoved -= onNodeRemoved;
			}
			nodeList = null;
		}
		
		override public function update( time : Number ) : void
		{
			for( var node : Node = nodeList.head; node; node = node.next )
			{
				nodeUpdateFunction( node, time );
			}
		}

		private function onNodeAdded( node : Node ) : void
		{
			nodeAddedFunction( node );
		}

		private function onNodeRemoved( node : Node ) : void
		{
			nodeRemovedFunction( node );
		}
	}
}
