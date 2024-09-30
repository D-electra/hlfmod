package fmod;

enum abstract FmodStudioInitFlags(Int) to Int {
	var FMOD_STUDIO_INIT_NORMAL                = 0x00000000;
	var FMOD_STUDIO_INIT_LIVEUPDATE            = 0x00000001;
	var FMOD_STUDIO_INIT_ALLOW_MISSING_PLUGINS = 0x00000002;
	var FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE    = 0x00000004;
	var FMOD_STUDIO_INIT_DEFERRED_CALLBACKS    = 0x00000008;
	var FMOD_STUDIO_INIT_LOAD_FROM_UPDATE      = 0x00000010;
	var FMOD_STUDIO_INIT_MEMORY_TRACKING       = 0x00000020;
}

enum abstract FmodInitFlags(Int) to Int {
	var FMOD_INIT_NORMAL                 = 0x00000000;
	var FMOD_INIT_STREAM_FROM_UPDATE     = 0x00000001;
	var FMOD_INIT_MIX_FROM_UPDATE        = 0x00000002;
	var FMOD_INIT_3D_RIGHTHANDED         = 0x00000004;
	var FMOD_INIT_CLIP_OUTPUT            = 0x00000008;
	var FMOD_INIT_CHANNEL_LOWPASS        = 0x00000100;
	var FMOD_INIT_CHANNEL_DISTANCEFILTER = 0x00000200;
	var FMOD_INIT_PROFILE_ENABLE         = 0x00010000;
	var FMOD_INIT_VOL0_BECOMES_VIRTUAL   = 0x00020000;
	var FMOD_INIT_GEOMETRY_USECLOSEST    = 0x00040000;
	var FMOD_INIT_PREFER_DOLBY_DOWNMIX   = 0x00080000;
	var FMOD_INIT_THREAD_UNSAFE          = 0x00100000;
	var FMOD_INIT_PROFILE_METER_ALL      = 0x00200000;
	var FMOD_INIT_MEMORY_TRACKING        = 0x00400000;
}

enum abstract FmodStudioLoadBankFlags(Int) to Int {
	var FMOD_STUDIO_LOAD_BANK_NORMAL = 0x00000000;
	var FMOD_STUDIO_LOAD_BANK_NONBLOCKING = 0x00000001;
	var FMOD_STUDIO_LOAD_BANK_DECOMPRESS_SAMPLES = 0x00000002;
	var FMOD_STUDIO_LOAD_BANK_UNENCRYPTED = 0x00000004;
}

typedef FmodBank = hl.Abstract<'FMOD::Studio::Bank*'>;

typedef FmodEventInstance = hl.Abstract<'FMOD::Studio::EventInstance*'>;

enum abstract FmodStudioStopMode(Int) to Int {
	var FMOD_STUDIO_STOP_ALLOWFADEOUT;
	var FMOD_STUDIO_STOP_IMMEDIATE;
}

@:access(String)
class Fmod {
	public static var version(get, never):Int;
	@:noCompletion
	static function get_version() return FmodHdll.version();

	public static function create(maxChannels = 36, studioFlags:FmodStudioInitFlags = FMOD_STUDIO_INIT_NORMAL, flags:FmodInitFlags = FMOD_INIT_NORMAL) {
		if (maxChannels == 0) maxChannels = 36;
		return FmodHdll.create(maxChannels, studioFlags, flags);
	}

	public static function update() {
		return FmodHdll.update();
	}

	public static function dispose() {
		return FmodHdll.dispose();
	}

	public static function loadBankFile(filename:String, flags:FmodStudioLoadBankFlags = FMOD_STUDIO_LOAD_BANK_NORMAL) {
		return FmodHdll.loadBankFile(filename.toUtf8(), flags);
	}

	public static function unloadBank(bank:FmodBank) {
		return FmodHdll.unloadBank(bank);
	}

	public static function createEvent(path:String) {
		return FmodHdll.createEvent(path.toUtf8());
	}

	public static function startEvent(event:FmodEventInstance) {
		return FmodHdll.startEvent(event);
	}

	public static function stopEvent(event:FmodEventInstance, mode:FmodStudioStopMode = FMOD_STUDIO_STOP_IMMEDIATE) {
		return FmodHdll.stopEvent(event, mode);
	}

	public static function setEventPaused(event:FmodEventInstance, paused:Bool) {
		return FmodHdll.setEventPaused(event, paused);
	}

	public static function getEventPaused(event:FmodEventInstance) {
		return FmodHdll.getEventPaused(event);
	}

	public static function disposeEvent(event:FmodEventInstance) {
		return FmodHdll.disposeEvent(event);
	}
}

private class FmodHdll {
	@:hlNative('fmod', 'version')
	public static function version():Int return 0;

	@:hlNative('fmod', 'create')
	public static function create(maxChannels:Int, studioFlags:Int, flags:Int):Void return;
	@:hlNative('fmod', 'update')
	public static function update():Void return;
	@:hlNative('fmod', 'dispose')
	public static function dispose():Void return;

	@:hlNative('fmod', 'loadBankFile')
	public static function loadBankFile(filename:hl.Bytes, flags:Int):FmodBank return null;
	@:hlNative('fmod', 'unloadBank')
	public static function unloadBank(bank:FmodBank):Void return;

	@:hlNative('fmod', 'createEvent')
	public static function createEvent(path:hl.Bytes):FmodEventInstance return null;
	@:hlNative('fmod', 'startEvent')
	public static function startEvent(event:FmodEventInstance):Void return;
	@:hlNative('fmod', 'stopEvent')
	public static function stopEvent(event:FmodEventInstance, mode:FmodStudioStopMode):Void return;
	@:hlNative('fmod', 'setEventPaused')
	public static function setEventPaused(event:FmodEventInstance, paused:Bool):Void return;
	@:hlNative('fmod', 'getEventPaused')
	public static function getEventPaused(event:FmodEventInstance):Bool return false;
	@:hlNative('fmod', 'disposeEvent')
	public static function disposeEvent(event:FmodEventInstance):Void return;
}
