package
{
	import ash.core.Entity;

	import pixeldroid.bdd.Spec;
	import pixeldroid.bdd.Thing;

	public static class EntitySpec
	{
		public static function describe():void
		{
			var it:Thing = Spec.describe('Entity');

			it.should('return a reference to an Entity', function() {
				var entity:Entity = new Entity();
				var component:MockComponent = new MockComponent();
				var e:Entity = entity.add(component);
				it.expects(e).toEqual(entity);
			});
		}
	}

	class MockComponent
	{
		public var value:Number;
	}
}
