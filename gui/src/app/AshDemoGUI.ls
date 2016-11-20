package
{

    import loom.Application;

    import pixeldroid.bdd.SpecExecutor;

    import AshSpec;
    import EntitySpec;


    public class AshDemoGUI extends Application
    {
        override public function run():void
        {
            SpecExecutor.addFormat(SpecExecutor.FORMAT_ANSI);

            SpecExecutor.exec([
                AshSpec,
                EntitySpec
            ]);
        }
    }

}
