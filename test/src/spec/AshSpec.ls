package
{
	import ash.core.Engine;

	import pixeldroid.bdd.Spec;
	import pixeldroid.bdd.Thing;

	public static class AshSpec
	{
		public static function describe():void
		{
			var it:Thing = Spec.describe('Ash');

			it.should('be versioned', function() {
				it.expects(Engine.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
			});
		}
	}
}
