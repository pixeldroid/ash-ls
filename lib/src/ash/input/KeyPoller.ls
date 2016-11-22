
package ash.input
{
	import loom.Application;
	import loom2d.events.EventDispatcher;
	import loom2d.events.KeyboardEvent;

	/**
	 * Provides `isDown` and `isUp` methods for polling the state of a given key.
	 */
	public class KeyPoller
	{
		private const buffer:Vector.<Boolean> = new Vector.<Boolean>(0xff);

		private var eventSource:EventDispatcher;

		/**
		 * Constructor
		 *
		 * @param eventSource the object to listen to for keyboard events. To catch all key events use `Loom2D.stage`.
		 */
		public function KeyPoller( eventSource:EventDispatcher )
		{
			this.eventSource = eventSource;

			Application.applicationActivated += onActivated;
			Application.applicationDeactivated += onDeactivated;

			onActivated();
			buffer.setFixed();
		}

		/**
		 * True when the key is down.
		 *
		 * @param keyCode code for the key to test.
		 * @return true if the key is down, false otherwise.
		 * @see isUp
		 */
		public function isDown( keyCode:Number ):Boolean
		{
			return buffer[keyCode];
		}

		/**
		 * True when the key is up.
		 *
		 * @param keyCode code for the key to test.
		 * @return true if the key is up, false otherwise.
		 * @see isDown
		 */
		public function isUp( keyCode:Number ):Boolean
		{
			return !buffer[keyCode];
		}


		private function resetBuffer():void
		{
			for (var index:Number in buffer) {
				buffer[index] = false;
			}
		}

		private function onKeyDown( e:KeyboardEvent ):void
		{
			buffer[e.keyCode] = true;
		}

		private function onKeyUp( e:KeyboardEvent ):void
		{
			buffer[e.keyCode] = false;
		}

		private function onActivated():void
		{
			resetBuffer();

			eventSource.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			eventSource.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onDeactivated():void
		{
			eventSource.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			eventSource.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			resetBuffer();
		}
	}
}
