
package ash.input
{
	import loom.platform.LoomKey;

	/**
	Provides methods for relating string characters to LoomKey codes.
	*/
	public class KeyMap
	{
		private static const CHAR_TO_LOOM_KEY:Dictionary.<String,Number> = {
			'A' : LoomKey.A,
			'B' : LoomKey.B,
			'C' : LoomKey.C,
			'D' : LoomKey.D,
			'E' : LoomKey.E,
			'F' : LoomKey.F,
			'G' : LoomKey.G,
			'H' : LoomKey.H,
			'I' : LoomKey.I,
			'J' : LoomKey.J,
			'K' : LoomKey.K,
			'L' : LoomKey.L,
			'M' : LoomKey.M,
			'N' : LoomKey.N,
			'O' : LoomKey.O,
			'P' : LoomKey.P,
			'Q' : LoomKey.Q,
			'R' : LoomKey.R,
			'S' : LoomKey.S,
			'T' : LoomKey.T,
			'U' : LoomKey.U,
			'V' : LoomKey.V,
			'W' : LoomKey.W,
			'X' : LoomKey.X,
			'Y' : LoomKey.Y,
			'Z' : LoomKey.Z,
			' ' : LoomKey.SPACEBAR,
			'`' : LoomKey.GRAVE,
			'~' : LoomKey.GRAVE,
			'1' : LoomKey.ONE,
			'!' : LoomKey.ONE,
			'2' : LoomKey.TWO,
			'@' : LoomKey.TWO,
			'3' : LoomKey.THREE,
			'#' : LoomKey.THREE,
			'4' : LoomKey.FOUR,
			'$' : LoomKey.FOUR,
			'5' : LoomKey.FIVE,
			'%' : LoomKey.FIVE,
			'6' : LoomKey.SIX,
			'^' : LoomKey.SIX,
			'7' : LoomKey.SEVEN,
			'&' : LoomKey.SEVEN,
			'8' : LoomKey.EIGHT,
			'*' : LoomKey.EIGHT,
			'9' : LoomKey.NINE,
			'(' : LoomKey.NINE,
			'0' : LoomKey.ZERO,
			')' : LoomKey.ZERO,
			'-' : LoomKey.HYPHEN,
			'_' : LoomKey.HYPHEN,
			'=' : LoomKey.EQUALS,
			'+' : LoomKey.EQUALS,
			'[' : LoomKey.LEFTBRACKET,
			'{' : LoomKey.LEFTBRACKET,
			']' : LoomKey.RIGHTBRACKET,
			'}' : LoomKey.RIGHTBRACKET,
			'\\' : LoomKey.BACKSLASH,
			'|' : LoomKey.BACKSLASH,
			';' : LoomKey.SEMICOLON,
			':' : LoomKey.SEMICOLON,
			"'" : LoomKey.APOSTROPHE,
			'"' : LoomKey.APOSTROPHE,
			',' : LoomKey.COMMA,
			'<' : LoomKey.COMMA,
			'.' : LoomKey.PERIOD,
			'>' : LoomKey.PERIOD,
			'/' : LoomKey.SLASH,
			'?' : LoomKey.SLASH,
		};

		/**
			Converts string characters to LoomKey codes
			@param char String character in ASCII range 32-126
			@see loom.platform.LoomKey
		*/
		public static function charToLoomKey(char:String):Number
		{
			var c:String = char.toUpperCase();
			var key:Number = CHAR_TO_LOOM_KEY[c] as Number;
			return key;
		}
	}
}
