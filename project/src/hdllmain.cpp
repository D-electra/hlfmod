#define HL_NAME(n) fmod_##n
#include "hl.h"

#include "fmod_studio.hpp"
#include "fmod_errors.h"

#include <map>

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

HL_PRIM void HL_NAME(dispose)() {
	FMOD_RESULT result = fmodSystem->release();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, dispose, _NO_ARG)

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

HL_PRIM FMOD::Studio::EventInstance* HL_NAME(createEvent)(vbyte* path) {
	FMOD::Studio::EventDescription* description{};
	FMOD::Studio::EventInstance* event{};

	FMOD_RESULT result = fmodSystem->getEvent((const char*)path, &description);
	if (result != FMOD_OK) {
		onError(result);
		return nullptr;
	}
	result = description->createInstance(&event);
	if (result != FMOD_OK) {
		onError(result);
		return nullptr;
	}
	return event;
}
DEFINE_PRIM(_ABSTRACT(FMOD::Studio::EventInstance*), createEvent, _BYTES)

HL_PRIM void HL_NAME(startEvent)(FMOD::Studio::EventInstance* event) {
	FMOD_RESULT result = event->start();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, startEvent, _ABSTRACT(FMOD::Studio::EventInstance*))

HL_PRIM void HL_NAME(stopEvent)(FMOD::Studio::EventInstance* event, int mode) {
	FMOD_RESULT result = event->stop((FMOD_STUDIO_STOP_MODE)mode);
}
DEFINE_PRIM(_VOID, stopEvent, _ABSTRACT(FMOD::Studio::EventInstance*) _I32)

HL_PRIM void HL_NAME(setEventPaused)(FMOD::Studio::EventInstance* event, bool paused) {
	FMOD_RESULT result = event->setPaused(paused);
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, setEventPaused, _ABSTRACT(FMOD::Studio::EventInstance*) _BOOL)

HL_PRIM bool HL_NAME(getEventPaused)(FMOD::Studio::EventInstance* event) {
	bool* paused{};
	
	FMOD_RESULT result = event->getPaused(paused);
	if (result != FMOD_OK) {
		onError(result);
		return false;
	}
	return *paused;
}
DEFINE_PRIM(_BOOL, getEventPaused, _ABSTRACT(FMOD::Studio::EventInstance*))

HL_PRIM void HL_NAME(disposeEvent)(FMOD::Studio::EventInstance* event) {
	FMOD_RESULT result = event->release();
	if (result != FMOD_OK) {
		onError(result);
	}
}
DEFINE_PRIM(_VOID, disposeEvent, _ABSTRACT(FMOD::Studio::EventInstance*))