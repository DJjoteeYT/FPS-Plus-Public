package;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.media.Sound;
import opendl.utils.Assets;

class Paths
{
	public static final imageCache:Map<String, FlxGraphic> = [];
	public static final soundCache:Map<String, Sound> = [];
	public static final extensions:Map<String, String> = [
		"image" => "png",
		"audio" => "ogg",
		"video" => "mp4"
	];

	inline static public function file(key:String, location:String, extension:String):String
	{
		var path:String = 'assets/$location/$key.$extension';
		return path;
	}

	inline static public function font(key:String, ?extension:String = "ttf"):String
	{
		var path:String = file(key, "fonts", extension);
		return path;
	}

	inline static public function xml(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "xml");
		return path;
	}

	inline static public function text(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "txt");
		return path;
	}

	inline static public function json(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "json");
		return path;
	}

	inline static public function image(key:String, ?location:String = "images"):FlxGraphic
	{
		var path:String = file(key, location, extensions.get("image"));
		var data:FlxGraphic = loadImage(path);
		return data;
	}

	inline static public function sound(key:String, ?location:String = "sounds"):Sound
	{
		var path:String = file(key, location, extensions.get("audio"));
		var data:Sound = loadSound(path);
		return data;
	}

	inline static public function music(key:String, ?location:String = "music"):Sound
	{
		var path:String = file(key, location, extensions.get("audio"));
		var data:Sound = loadSound(path);
		return data;
	}

	inline static public function voices(key:String, ?location:String = "songs"):Sound
	{
		var path:String = file('$key/Voices', location, extensions.get("audio"));
		var data:Sound = loadSound(path);
		return data;
	}

	inline static public function inst(key:String, ?location:String = "songs"):Sound
	{
		var path:String = file('$key/Inst', location, extensions.get("audio"));
		var data:Sound = loadSound(path);
		return data;
	}

	inline static public function video(key:String, ?location:String = "videos"):String
	{
		var path:String = file(key, location, extensions.get("video"));
		return path;
	}

	inline static public function getSparrowAtlas(key:String, ?location:String = "images"):FlxAtlasFrames
	{
		var atlasFrames:FlxAtlasFrames = FlxAtlasFrames.fromSparrow(image(key, location), xml(key, location));
		return atlasFrames;
	}

	inline static public function getPackerAtlas(key:String, ?location:String = "images"):FlxAtlasFrames
	{
		var atlasFrames:FlxAtlasFrames = FlxAtlasFrames.fromSpriteSheetPacker(image(key, location), text(key, location));
		return atlasFrames;
	}

	public static function loadImage(path:String):FlxGraphic
	{
		if (Assets.exists(path, IMAGE))
		{
			if (!imageCache.exists(path))
			{
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(GPUBitmap.create(path));
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
				imageCache.set(path, graphic);
			}
			else
				trace('$path is already loaded!');

			return imageCache.get(path);
		}
		else
			trace('$path is null!');

		return null;
	}

	public static function loadSound(path:String):Sound
	{
		if (Assets.exists(path, SOUND))
		{
			if (!soundCache.exists(path))
			{
				var sound:Sound = Assets.getSound(path);
				soundCache.set(path, sound);
			}
			else
				trace('$path is already loaded!');

			return soundCache.get(path);
		}
		else
			trace('$path is null!');

		return null;
	}
}
