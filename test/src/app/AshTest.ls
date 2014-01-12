
package
{

	import loom.Application;

	import pixeldroid.bdd.Spec;
	import pixeldroid.bdd.reporters.ConsoleReporter;

	import AshSpec;
	import EntitySpec;


	public class AshTest extends Application
	{
		override public function run():void
		{
			AshSpec.describe();
			EntitySpec.describe();

			Spec.addReporter(new ConsoleReporter());
			Spec.execute();
		}
	}
}