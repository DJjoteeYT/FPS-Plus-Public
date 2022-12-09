package config;

import openfl.media.Sound;
import title.*;
import config.*;
import transition.data.*;
import flixel.FlxState;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import openfl.system.System;

// import openfl.utils.Future;
// import flixel.addons.util.FlxAsyncLoop;
using StringTools;

class CacheReload extends FlxState
{
	public static var doMusic = true;
	public static var doGraphics = true;

	var nextState:FlxState = new ConfigMenu();

	var splash:FlxSprite;
	// var dummy:FlxSprite;
	var loadingText:FlxText;

	var songsCached:Bool;

	var charactersCached:Bool;
	var startCachingCharacters:Bool = false;
	var charI:Int = 0;

	var graphicsCached:Bool;
	var startCachingGraphics:Bool = false;
	var gfxI:Int = 0;

	var cacheStart:Bool = false;

	override function create()
	{
		songsCached = !FlxG.save.data.musicPreload2;
		charactersCached = !FlxG.save.data.charPreload2;
		graphicsCached = !FlxG.save.data.graphicsPreload2;

		if (doGraphics)
		{
			GPUBitmap.disposeAll();
			Assets.cache.clear("images");
			Paths.imageCache.clear();
		}
		else
		{
			charactersCached = true;
			graphicsCached = true;
		}

		if (doMusic)
		{
			Assets.cache.clear("songs");
			Assets.cache.clear("music");
			Assets.cache.clear("sounds");
			Paths.soundCache.clear();
		}
		else
		{
			songsCached = true;
		}

		System.gc();

		var text = new FlxText(0, 0, 1280, "LOADING ASSETS...", 64);
		text.scrollFactor.set(0, 0);
		text.setFormat(Paths.font("vcr"), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.borderSize = 3;
		text.borderQuality = 1;
		text.screenCenter(XY);
		add(text);

		preload();
		cacheStart = true;

		super.create();
	}

	override function update(elapsed)
	{
		if (songsCached && charactersCached && graphicsCached)
		{
			System.gc();
			FlxG.switchState(nextState);
		}

		if (startCachingCharacters)
		{
			if (charI >= Startup.characters.length)
			{
				// loadingText.text = "Characters cached...";
				// FlxG.sound.play(Paths.sound("tick"), 1);
				startCachingCharacters = false;
				charactersCached = true;
			}
			else
			{
				Paths.loadImage(Paths.file(Startup.characters[charI], "images", Paths.extensions.get("image")));
				charI++;
			}
		}

		if (startCachingGraphics)
		{
			if (gfxI >= Startup.graphics.length)
			{
				startCachingGraphics = false;
				graphicsCached = true;
			}
			else
			{
				Paths.loadImage(Paths.file(Startup.graphics[gfxI], "images", Paths.extensions.get("image")));
				gfxI++;
			}
		}

		super.update(elapsed);
	}

	function preload()
	{
		if (!songsCached)
		{
			#if sys
			sys.thread.Thread.create(() ->
			{
				preloadMusic();
			});
			#else
			preloadMusic();
			#end
		}

		if (!charactersCached)
		{
			startCachingCharacters = true;
		}

		if (!graphicsCached)
		{
			startCachingGraphics = true;
		}
	}

	function preloadMusic()
	{
		for (x in songs)
		{
			if (Paths.inst(x) != null)
				Paths.inst(x);

			if (Paths.music(x) != null)
				Paths.music(x);

			if (Paths.sound(x) != null)
				Paths.sound(x);
		}

		songsCached = true;
	}
}
