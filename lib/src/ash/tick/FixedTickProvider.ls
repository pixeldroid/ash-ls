package ash.tick
{
	import ash.tick.ITickProvider;

	import loom.Application;

	/**
	 * Listeners for the add() and remove() methods are expected to implement the FixedTickUpdate signature.
	 * @param time The fixed duration (in seconds) sent with each tick, scaled by the timeAdjustment factor.
	 */
	public delegate FixedTickUpdate(time:Number):void;

	/**
	 * Provides a frame tick with a fixed frame duration (in seconds), scaled by the timeAdjustment factor.
	 * This tick ignores the actual elapsed time between frames and reports the same duration for each tick.
	 */
	public class FixedTickProvider implements ITickProvider
	{
		private const update:FixedTickUpdate;

		private var frameTime:Number;
		private var isPlaying:Boolean = false;

		/**
		 * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire engine.
		 * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
		 */
		public var timeAdjustment:Number = 1.0;


		public function FixedTickProvider(frameTime:Number)
		{
			this.frameTime = frameTime;
		}

		public function add(listener:Function):void
		{
			update += listener;
		}

		public function remove(listener:Function):void
		{
			update -= listener;
		}

		public function start():void
		{
			Application.ticks += onTick;
			isPlaying = true;
		}

		public function stop():void
		{
			isPlaying = false;
			Application.ticks -= onTick;
		}

		public function get playing():Boolean
		{
			return isPlaying;
		}


		private function onTick():void
		{
			update(frameTime*timeAdjustment);
		}
	}
}
