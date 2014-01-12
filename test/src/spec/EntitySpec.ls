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
			var entity:Entity;

			it.should('return a reference to the Entity when adding components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				var e:Entity = entity.add(component);
				it.expects(e).toEqual(entity);
			});

			it.should('store and retrieve components of differing types', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponent2 = new MockComponent2();
				entity.add(component2);
				it.expects(entity.getComponent(MockComponent)).toEqual(component);
				it.expects(entity.getComponent(MockComponent2)).toEqual(component2);
			});

			it.should('replace components of the same type', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponent = new MockComponent();
				entity.add(component2);
				it.expects(component).not.toEqual(component2);
				it.expects(entity.getComponent(MockComponent)).toEqual(component2);
			});

			it.should('store base and extended components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponentExtended = new MockComponentExtended();
				entity.add(component2);
				it.expects(entity.getComponent(MockComponent)).toEqual(component);
				it.expects(entity.getComponent(MockComponentExtended)).toEqual(component2);
			});

			it.should('store extended components as base type', function() {
				entity = new Entity();
				var component:MockComponentExtended = new MockComponentExtended();
				entity.add(component, MockComponent);
				it.expects(entity.getComponent(MockComponent)).toEqual(component);
				it.expects(entity.getComponent(MockComponentExtended)).toBeNull();
			});

			it.should('retrieve null when no components match given type', function() {
				entity = new Entity();
				it.expects(entity.getComponent(MockComponent)).toBeNull();
			});

			it.should('retrieve all components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponent2 = new MockComponent2();
				entity.add(component2);
				var all:Vector.<Object> = entity.getAll();
				it.expects(all.length).toEqual(2);
				it.expects(all).toContain(component);
				it.expects(all).toContain(component2);
			});

			it.should('report false when no components match given type', function() {
				entity = new Entity();
				it.expects(entity.has(MockComponent)).toBeFalsey();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				it.expects(entity.has(MockComponent2)).toBeFalsey();
			});

			it.should('report true when at least one component matches given type', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				it.expects(entity.has(MockComponent)).toBeTruthy();
				var component2:MockComponent = new MockComponent();
				entity.add(component2);
				it.expects(entity.has(MockComponent)).toBeTruthy();
			});

			it.should('remove components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				entity.remove(MockComponent);
				it.expects(entity.has(MockComponent)).toBeFalsey();
				var all:Vector.<Object> = entity.getAll();
				it.expects(all.length).toEqual(0);
			});
		}
	}

	class MockComponent
	{
		public var value:Number;
	}

	class MockComponent2
	{
		public var value:Number;
	}

	class MockComponentExtended extends MockComponent
	{
		public var other:Number;
	}
}
