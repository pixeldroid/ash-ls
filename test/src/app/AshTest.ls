
package
{

	import loom.Application;

	import pixeldroid.bdd.Spec;
	import pixeldroid.bdd.reporters.ConsoleReporter;

	import AshSpec;


	public class AshTest extends Application
	{
		override public function run():void
		{
			AshSpec.describe();

			Spec.addReporter(new ConsoleReporter());
			Spec.execute();
		}
	}
}