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
				it.expects(entity.fetch(MockComponent)).toEqual(component);
				it.expects(entity.fetch(MockComponent2)).toEqual(component2);
			});

			it.should('replace components of the same type', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponent = new MockComponent();
				entity.add(component2);
				it.expects(component).not.toEqual(component2);
				it.expects(entity.fetch(MockComponent)).toEqual(component2);
			});

			it.should('store base and extended components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponentExtended = new MockComponentExtended();
				entity.add(component2);
				it.expects(entity.fetch(MockComponent)).toEqual(component);
				it.expects(entity.fetch(MockComponentExtended)).toEqual(component2);
			});

			it.should('store extended components as base type', function() {
				entity = new Entity();
				var component:MockComponentExtended = new MockComponentExtended();
				entity.add(component, MockComponent);
				it.expects(entity.fetch(MockComponent)).toEqual(component);
				it.expects(entity.fetch(MockComponentExtended)).toBeNull();
			});

			it.should('retrieve null when no components match given type', function() {
				entity = new Entity();
				it.expects(entity.fetch(MockComponent)).toBeNull();
			});

			it.should('retrieve all components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				entity.add(component);
				var component2:MockComponent2 = new MockComponent2();
				entity.add(component2);
				var all:Vector.<Object> = entity.fetchAll();
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
				var all:Vector.<Object> = entity.fetchAll();
				it.expects(all.length).toEqual(0);
			});

			it.should('trigger delegates when adding components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				var delegateCalled:Boolean = false;
				entity.componentAdded += function(owner:Entity, flavor:Type) {
					delegateCalled = true;
					it.expects(owner).toEqual(entity);
					it.expects(flavor).toEqual(MockComponent);
				};
				entity.add(component);
				it.expects(delegateCalled).toBeTruthy();
			});

			it.should('trigger delegates when removing components', function() {
				entity = new Entity();
				var component:MockComponent = new MockComponent();
				var delegateCalled:Boolean = false;
				entity.add(component);
				entity.componentRemoved += function(owner:Entity, flavor:Type) {
					delegateCalled = true;
					it.expects(owner).toEqual(entity);
					it.expects(flavor).toEqual(MockComponent);
				};
				entity.remove(MockComponent);
				it.expects(delegateCalled).toBeTruthy();
			});

			it.should('have a name by default', function() {
				entity = new Entity();
				it.expects(entity.name).not.toBeEmpty();
			});

			it.should('keep a given name', function() {
				var customName:String = 'custom name';
				entity = new Entity(customName);
				it.expects(entity.name).toEqual(customName);
			});

			it.should('allow its name to be changed', function() {
				var name:String = 'first choice';
				entity = new Entity(name);
				var name2:String = 'second choice';
				entity.name = name2;
				it.expects(entity.name).toEqual(name2);
			});

			it.should('trigger delegates when changing name', function() {
				var name:String = 'first choice';
				entity = new Entity(name);
				var delegateCalled:Boolean = false;
				var name2:String = 'second choice';
				entity.nameChanged += function(owner:Entity, oldName:String) {
					delegateCalled = true;
					it.expects(owner).toEqual(entity);
					it.expects(oldName).toEqual(name);
					it.expects(owner.name).toEqual(name2);
				};
				entity.name = name2;
				it.expects(delegateCalled).toBeTruthy();
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
