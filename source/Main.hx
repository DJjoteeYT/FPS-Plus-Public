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

		addChild(new FlxGame(1280, 720, Startup, 1, 144, 144, true));

		#if !mobile
		fpsDisplay = new Overlay(10, 3);
		fpsDisplay.visible = true;
		addChild(fpsDisplay);
		#end

		trace("-=Args=-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
	}
}
