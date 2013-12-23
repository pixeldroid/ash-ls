package ash.integration.loom
{
	import ash.tick.ITickProvider;
	import loom2d.animation.IAnimatable;
	import loom2d.animation.Juggler;

	public delegate Update( time : Number ) : void;

	/**
	 * Uses a Starling juggler to provide a frame tick with a fixed frame duration. This tick ignores the length of
	 * the frame and dispatches the same time period for each tick.
	 */
	public class LoomFixedTickProvider implements ITickProvider, IAnimatable
	{
		private var juggler : Juggler;
		private var frameTime : Number;
		private var isPlaying : Boolean = false;
		private var update : Update;
		
		/**
		 * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire engine.
		 * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
		 */
		public var timeAdjustment : Number = 1;
		
		public function LoomFixedTickProvider( juggler : Juggler, frameTime : Number )
		{
			this.juggler = juggler;
			this.frameTime = frameTime;
		}

		public function add( listener : Function ) : void
		{
			update += listener;
		}

		public function remove( listener : Function ) : void
		{
			update -= listener;
		}
		
		public function start() : void
		{
			juggler.add( this );
			isPlaying = true;
		}
		
		public function stop() : void
		{
			isPlaying = false;
			juggler.remove( this );
		}
		
		public function advanceTime( frameTime : Number ) : void
		{
			update( frameTime * timeAdjustment );
		}

		public function get playing() : Boolean
		{
			return isPlaying;
		}
	}
}
