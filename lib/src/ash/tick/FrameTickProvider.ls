package ash.tick
{
	import ash.tick.ITickProvider;

	import loom.Application;
	import system.platform.Platform;

	/**
	 * Listeners for the add() and remove() methods are expected to implement the FrameTickUpdate signature.
	 * @param elapsedSec The elapsed duration since last frame, in seconds, scaled by the timeAdjustment factor.
	 */
	public delegate FrameTickUpdate(elapsedSec:Number):void;

	/**
	 * Provides a frame tick where the tick duration is the time, in seconds, since the previous frame, scaled by the timeAdjustment factor.
	 * There is a maximum frame time parameter in the constructor that can be used to limit the longest duration reported in a tick.
	 */
	public class FrameTickProvider implements ITickProvider
	{
		private const update:FrameTickUpdate;

		private var previousTime:Number;
		private var maximumFrameTime:Number;
		private var isPlaying:Boolean = false;

		/**
		 * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire engine.
		 * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
		 */
		public var timeAdjustment:Number = 1.0;


		public function FrameTickProvider(maximumFrameTime:Number = Number.MAX_VALUE)
		{
			this.maximumFrameTime = maximumFrameTime;
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
			previousTime = Platform.getTime();
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
			var now:Number = Platform.getTime();
			var frameTime:Number = (now - previousTime) / 1000.0;
			if(frameTime > maximumFrameTime)
			{
				frameTime = maximumFrameTime;
			}
			previousTime = now;
			update(frameTime * timeAdjustment);
		}
	}
}
