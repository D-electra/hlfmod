#define HL_NAME(n) fmod_##n
#include "hl.h"

#include "fmod_studio.hpp"
#include "fmod_errors.h"

void onError(FMOD_RESULT result) {
	printf("%s\n", FMOD_ErrorString(result));
}

HL_PRIM int HL_NAME(version)() {
	return FMOD_VERSION;
}
DEFINE_PRIM(_I32, version, _NO_ARG)

FMOD::Studio::System* fmodSystem{};

HL_PRIM void HL_NAME(create)(int maxChannels, int studioFlags, int flags) {
	FMOD_RESULT result = FMOD::Studio::System::create(&fmodSystem);
	if (result != FMOD_OK) {
		onError(result);
	}
	result = fmodSystem->initialize(maxChannels, studioFlags, flags, nullptr);
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, create, _I32 _I32 _I32)

HL_PRIM void HL_NAME(update)() {
	FMOD_RESULT result = fmodSystem->update();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, update, _NO_ARG)

HL_PRIM void HL_NAME(release)() {
	FMOD_RESULT result = fmodSystem->release();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, release, _NO_ARG)

HL_PRIM FMOD::Studio::Bank* HL_NAME(loadBankFile)(vbyte* filename, int flags) {
	FMOD::Studio::Bank* bank{};
	FMOD_RESULT result = fmodSystem->loadBankFile((const char*)filename, flags, &bank);
	if (result != FMOD_OK) {
		onError(result);
		return nullptr;
	}
	return bank;
}
DEFINE_PRIM(_ABSTRACT(FMOD::Studio::Bank*), loadBankFile, _BYTES _I32)

HL_PRIM void HL_NAME(unloadBank)(FMOD::Studio::Bank* bank) {
	FMOD_RESULT result = bank->unload();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, unloadBank, _ABSTRACT(FMOD::Studio::Bank*))

HL_PRIM FMOD::Studio::EventDescription* HL_NAME(getEvent)(vbyte* path) {
	FMOD::Studio::EventDescription* description{};

	FMOD_RESULT result = fmodSystem->getEvent((const char*)path, &description);
	if (result != FMOD_OK) {
		onError(result);
		return nullptr;
	}
	return description;
}
DEFINE_PRIM(_ABSTRACT(FMOD::Studio::EventDescription*), getEvent, _BYTES)

HL_PRIM FMOD::Studio::EventInstance* HL_NAME(createInstance)(FMOD::Studio::EventDescription* description) {
	FMOD::Studio::EventInstance* instance;

	FMOD_RESULT result = description->createInstance(&instance);
	if (result != FMOD_OK) {
		onError(result);
		return nullptr;
	}
	return instance;
}
DEFINE_PRIM(_ABSTRACT(FMOD::Studio::EventInstance*), createInstance, _ABSTRACT(FMOD::Studio::EventDescription*))

HL_PRIM void HL_NAME(startInstance)(FMOD::Studio::EventInstance* instance) {
	FMOD_RESULT result = instance->start();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, startInstance, _ABSTRACT(FMOD::Studio::EventInstance*))

HL_PRIM void HL_NAME(stopInstance)(FMOD::Studio::EventInstance* instance, int mode) {
	FMOD_RESULT result = instance->stop((FMOD_STUDIO_STOP_MODE)mode);
}
DEFINE_PRIM(_VOID, stopInstance, _ABSTRACT(FMOD::Studio::EventInstance*) _I32)

HL_PRIM void HL_NAME(setInstancePaused)(FMOD::Studio::EventInstance* instance, bool paused) {
	FMOD_RESULT result = instance->setPaused(paused);
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, setInstancePaused, _ABSTRACT(FMOD::Studio::EventInstance*) _BOOL)

HL_PRIM bool HL_NAME(getInstancePaused)(FMOD::Studio::EventInstance* instance) {
	bool* paused{};
	
	FMOD_RESULT result = instance->getPaused(paused);
	if (result != FMOD_OK) {
		onError(result);
		return false;
	}
	return *paused;
}
DEFINE_PRIM(_BOOL, getInstancePaused, _ABSTRACT(FMOD::Studio::EventInstance*))

HL_PRIM void HL_NAME(releaseInstance)(FMOD::Studio::EventInstance* instance) {
	FMOD_RESULT result = instance->release();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, releaseInstance, _ABSTRACT(FMOD::Studio::EventInstance*))