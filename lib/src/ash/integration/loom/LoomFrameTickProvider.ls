package ash.integration.starling
{
	import ash.tick.ITickProvider;
	import loom2d.animation.IAnimatable;
	import loom2d.animation.Juggler;

	public delegate Update( time : Number ) : void;

	/**
	 * Uses a Starling juggler to provide a frame tick where the frame duration is the time since the previous frame.
	 * There is a maximum frame time parameter in the constructor that can be used to limit
	 * the longest period a frame can be.
	 */
	public class LoomFrameTickProvider implements ITickProvider, IAnimatable
	{
		private var juggler : Juggler;
		private var maximumFrameTime : Number;
		private var isPlaying : Boolean = false;
		private var update : Update;
		
		/**
		 * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire engine.
		 * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
		 */
		public var timeAdjustment : Number = 1;
		
		public function LoomFrameTickProvider( juggler : Juggler, maximumFrameTime : Number = Number.MAX_VALUE )
		{
			this.juggler = juggler;
			this.maximumFrameTime = maximumFrameTime;
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
			if( frameTime > maximumFrameTime )
			{
				frameTime = maximumFrameTime;
			}
			update( frameTime * timeAdjustment );
		}

		public function get playing() : Boolean
		{
			return isPlaying;
		}
	}
}
