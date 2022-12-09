package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsDisplay:Overlay;
	public static var novid:Bool = false;
	public static var flippymode:Bool = false;

	public function new()
	{
		super();

		SUtil.uncaughtErrorHandler();

		#if sys
		novid = Sys.args().contains("-novid");
		flippymode = Sys.args().contains("-flippymode");
		#end

		SUtil.checkPermissions();

		#if (flixel <= "5.0.0")
		addChild(new FlxGame(1280, 720, Startup, 144, 144, true));
		#else
		addChild(new FlxGame(1280, 720, Startup, 1, 144, 144, true));
		#end

		fpsDisplay = new Overlay(10, 3);
		fpsDisplay.visible = true;
		addChild(fpsDisplay);

		trace("-=Args=-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
	}
}
