package fmod;

enum abstract FmodStudioInitFlags(Int) from Int to Int {
	var FMOD_STUDIO_INIT_NORMAL                = 0x00000000;
	var FMOD_STUDIO_INIT_LIVEUPDATE            = 0x00000001;
	var FMOD_STUDIO_INIT_ALLOW_MISSING_PLUGINS = 0x00000002;
	var FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE    = 0x00000004;
	var FMOD_STUDIO_INIT_DEFERRED_CALLBACKS    = 0x00000008;
	var FMOD_STUDIO_INIT_LOAD_FROM_UPDATE      = 0x00000010;
	var FMOD_STUDIO_INIT_MEMORY_TRACKING       = 0x00000020;
}

enum abstract FmodInitFlags(Int) from Int to Int {
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

enum abstract FmodStudioLoadBankFlags(Int) from Int to Int {
	var FMOD_STUDIO_LOAD_BANK_NORMAL = 0x00000000;
	var FMOD_STUDIO_LOAD_BANK_NONBLOCKING = 0x00000001;
	var FMOD_STUDIO_LOAD_BANK_DECOMPRESS_SAMPLES = 0x00000002;
	var FMOD_STUDIO_LOAD_BANK_UNENCRYPTED = 0x00000004;
}

enum abstract FmodStudioStopMode(Int) from Int to Int {
	var FMOD_STUDIO_STOP_ALLOWFADEOUT;
	var FMOD_STUDIO_STOP_IMMEDIATE;
}

enum abstract FmodStudioPlaybackState(Int) from Int to Int {
	var FMOD_STUDIO_PLAYBACK_PLAYING;
	var FMOD_STUDIO_PLAYBACK_SUSTAINING;
	var FMOD_STUDIO_PLAYBACK_STOPPED;
	var FMOD_STUDIO_PLAYBACK_STARTING;
	var FMOD_STUDIO_PLAYBACK_STOPPING;
}

private typedef FmodBankAbs = hl.Abstract<'FMOD::Studio::Bank*'>;
abstract FmodBank(FmodBankAbs) from FmodBankAbs to FmodBankAbs {
	public function unload() {
		FmodHdll.unloadBank(this);
	}
}

private typedef FmodEventDescriptionAbs = hl.Abstract<'FMOD::Studio::EventDescription*'>;
abstract FmodEventDescription(FmodEventDescriptionAbs) from FmodEventDescriptionAbs to FmodEventDescriptionAbs {
	public function createInstance():FmodEventInstance {
		return FmodHdll.createInstance(this);
	}
}

private typedef FmodEventInstanceAbs = hl.Abstract<'FMOD::Studio::EventInstance*'>;
abstract FmodEventInstance(FmodEventInstanceAbs) from FmodEventInstanceAbs to FmodEventInstanceAbs {
	public function start() {
		FmodHdll.startInstance(this);
	}

	public function stop(mode:FmodStudioStopMode) {
		FmodHdll.stopInstance(this, mode);
	}

	public function setVolume(volume:Float) {
		FmodHdll.setInstanceVolume(this, volume);
	}

	public function getVolume():Float {
		return FmodHdll.getInstanceVolume(this);
	}

	public function setPaused(paused:Bool) {
		FmodHdll.setInstancePaused(this, paused);
	}

	public function getPaused():Bool {
		return FmodHdll.getInstancePaused(this);
	}

	public function setTimelinePosition(position:Int) {
		FmodHdll.setInstanceTimelinePosition(this, position);
	}

	public function getTimelinePosition():Int {
		return FmodHdll.getInstanceTimelinePosition(this);
	}

	public function setPitch(pitch:Float) {
		FmodHdll.setInstancePitch(this, pitch);
	}

	public function getPitch():Float {
		return FmodHdll.getInstancePitch(this);
	}

	public function getPlaybackState():FmodStudioPlaybackState {
		return FmodHdll.getInstancePlaybackState(this);
	}

	public function release() {
		FmodHdll.releaseInstance(this);
	}
}

class Fmod {
	public static function version():Int {
		return FmodHdll.version();
	}

	public static function create(maxChannels = 36, studioFlags:FmodStudioInitFlags = FMOD_STUDIO_INIT_NORMAL, flags:FmodInitFlags = FMOD_INIT_NORMAL) {
		FmodHdll.create(maxChannels, studioFlags, flags);
	}

	public static function update() {
		FmodHdll.update();
	}

	public static function release() {
		FmodHdll.release();
	}

	public static function loadBankFile(filename:String, flags:FmodStudioLoadBankFlags = FMOD_STUDIO_LOAD_BANK_NORMAL):FmodBank {
		return FmodHdll.loadBankFile(@:privateAccess filename.toUtf8(), flags);
	}

	public static function getEvent(path:String):FmodEventDescription {
		return FmodHdll.getEvent(@:privateAccess path.toUtf8());
	}
}

private class FmodHdll {
	@:hlNative('fmod', 'version')
	public static function version():Int return 0;

	@:hlNative('fmod', 'create')
	public static function create(maxChannels:Int, studioFlags:Int, flags:Int):Void return;
	@:hlNative('fmod', 'update')
	public static function update():Void return;
	@:hlNative('fmod', 'release')
	public static function release():Void return;

	@:hlNative('fmod', 'loadBankFile')
	public static function loadBankFile(filename:hl.Bytes, flags:Int):FmodBankAbs return null;
	@:hlNative('fmod', 'unloadBank')
	public static function unloadBank(bank:FmodBankAbs):Void return;

	@:hlNative('fmod', 'getEvent')
	public static function getEvent(path:hl.Bytes):FmodEventDescriptionAbs return null;

	@:hlNative('fmod', 'createInstance')
	public static function createInstance(description:FmodEventDescriptionAbs):FmodEventInstanceAbs return null;

	@:hlNative('fmod', 'startInstance')
	public static function startInstance(instance:FmodEventInstanceAbs):Void return;

	@:hlNative('fmod', 'stopInstance')
	public static function stopInstance(instance:FmodEventInstanceAbs, mode:Int):Void return;

	@:hlNative('fmod', 'setInstanceVolume')
	public static function setInstanceVolume(instance:FmodEventInstanceAbs, volume:hl.F32):Void return;
	@:hlNative('fmod', 'getInstanceVolume')
	public static function getInstanceVolume(instance:FmodEventInstanceAbs):hl.F32 return 0;

	@:hlNative('fmod', 'setInstancePaused')
	public static function setInstancePaused(instance:FmodEventInstanceAbs, paused:Bool):Void return;
	@:hlNative('fmod', 'getInstancePaused')
	public static function getInstancePaused(instance:FmodEventInstanceAbs):Bool return false;

	@:hlNative('fmod', 'setInstanceTimelinePosition')
	public static function setInstanceTimelinePosition(instance:FmodEventInstanceAbs, position:Int):Void return;
	@:hlNative('fmod', 'getInstanceTimelinePosition')
	public static function getInstanceTimelinePosition(instance:FmodEventInstanceAbs):Int return 0;

	@:hlNative('fmod', 'setInstancePitch')
	public static function setInstancePitch(instance:FmodEventInstanceAbs, pitch:hl.F32):Void return;
	@:hlNative('fmod', 'getInstancePitch')
	public static function getInstancePitch(instance:FmodEventInstanceAbs):hl.F32 return 0;

	@:hlNative('fmod', 'getInstancePlaybackState')
	public static function getInstancePlaybackState(instance:FmodEventInstanceAbs):Int return 0;

	@:hlNative('fmod', 'releaseInstance')
	public static function releaseInstance(instance:FmodEventInstanceAbs):Void return;
}
