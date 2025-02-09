package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.io.Path;
import openfl.media.Sound;
import openfl.system.System;
import openfl.utils.Assets;

enum AssetsType
{
	ALL;
	IMAGES;
	SOUNDS;
}

enum ClearingType
{
	ALL;
	UNUSED;
	STORED;
}

class Paths
{
	public static final extensions:Map<String, String> = ["image" => "png", "audio" => "ogg", "video" => "mp4"];

	public static var imagesCache:Map<String, FlxGraphic> = [];
	public static var soundsCache:Map<String, Sound> = [];

	public static var excludedImages:Array<String> = [];
	public static var excludedSounds:Array<String> = [];
	public static var trackedAssets:Array<String> = [];

	public static function clearCache(?assets:AssetsType = ALL, ?clearing:ClearingType = ALL, ?clearExcludedAssets:Bool = false):Void
	{
		if (excludedImages.length > 0 && (assets == IMAGES || assets == ALL) && clearExcludedAssets)
			excludedImages = [];

		if (excludedSounds.length > 0 && (assets == SOUNDS || assets == ALL) && clearExcludedAssets)
			excludedSounds = [];

		if (assets == IMAGES || assets == ALL)
		{
			if (clearing == STORED || clearing == ALL)
			{
				@:privateAccess
				for (key in FlxG.bitmap._cache.keys())
				{
					if (!imagesCache.exists(key) && !excludedImages.contains(key) && key != null)
					{
						var obj = FlxG.bitmap._cache.get(key);
						@:privateAccess
						if (obj != null)
						{
							Assets.cache.removeBitmapData(key);
							Assets.cache.clearBitmapData(key);
							Assets.cache.clear(key);
							FlxG.bitmap._cache.remove(key);
							obj.destroy();
						}
					}
				}
			}

			if (clearing == UNUSED || clearing == ALL)
			{
				for (key in imagesCache.keys())
				{
					if (!trackedAssets.contains(key) && !excludedImages.contains(key) && key != null)
					{
						var obj = imagesCache.get(key);
						@:privateAccess
						if (obj != null)
						{
							Assets.cache.removeBitmapData(key);
							Assets.cache.clearBitmapData(key);
							Assets.cache.clear(key);
							FlxG.bitmap._cache.remove(key);
							obj.destroy();
							imagesCache.remove(key);
						}
					}
				}
			}
		}

		if (assets == SOUNDS || assets == ALL)
		{
			if (clearing == STORED || clearing == ALL)
			{
				@:privateAccess
				for (key in Assets.cache.getSoundKeys())
				{
					if (!soundsCache.exists(key) && !excludedSounds.contains(key) && key != null)
					{
						var obj = Assets.cache.getSound(key);
						@:privateAccess
						if (obj != null)
						{
							Assets.cache.removeSound(key);
							Assets.cache.clearSounds(key);
							Assets.cache.clear(key);
						}
					}
				}
			}

			if (clearing == UNUSED || clearing == ALL)
			{
				for (key in soundsCache.keys())
				{
					if (!trackedAssets.contains(key) && !excludedSounds.contains(key) && key != null)
					{
						var obj = soundsCache.get(key);
						if (obj != null)
						{
							Assets.cache.removeSound(key);
							Assets.cache.clearSounds(key);
							Assets.cache.clear(key);
							soundsCache.remove(key);
						}
					}
				}
			}
		}

		if (trackedAssets.length > 0 && (clearing == UNUSED || clearing == ALL))
			trackedAssets = [];

		// run the garbage collector for good measure lmao
		System.gc();
	}

	public static function excludeAsset(path:String):Void
	{
		if (path != null)
		{
			if (Path.extension(path) == extensions.get("image"))
				excludedImages.push(path);
			else if (Path.extension(path) == extensions.get("audio"))
				excludedSounds.push(path);
		}
	}

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

	public static function loadImage(path:String, ?exclude:Bool = false):FlxGraphic
	{
		if (Assets.exists(path, IMAGE))
		{
			if (!imagesCache.exists(path))
			{
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(#if desktop GPUBitmap.create(path) #else Assets.getBitmapData(path) #end);
				graphic.persist = true;
				graphic.destroyOnNoUse = false;
				imagesCache.set(path, graphic);

				if (exclude)
					excludedImages.push(path);
			}
			else
				trace('$path is already loaded!');

			return imagesCache.get(path);
		}
		else
			trace('$path is null!');

		return null;
	}

	public static function loadSound(path:String, ?exclude:Bool = false):Sound
	{
		if (Assets.exists(path, SOUND))
		{
			if (!soundsCache.exists(path))
			{
				var sound:Sound = Assets.getSound(path);
				soundsCache.set(path, sound);

				if (exclude)
					excludedSounds.push(path);
			}
			else
				trace('$path is already loaded!');

			return soundsCache.get(path);
		}
		else
			trace('$path is null!');

		return null;
	}
}
