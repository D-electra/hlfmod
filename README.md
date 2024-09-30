# HLFMOD

Haxe/HL bindings for FMOD Studio API

### How to use

Copy files from [redist](https://github.com/D-electra/hlfmod/tree/main/redist) to your hashlink directory

Here is the usage example:

```haxe
import fmod.Fmod;

var master:FmodBank;
var master_strings:FmodBank;
var sfx:FmodBank;

function main() {
	trace('FMOD version: ${fmod.Api.version()}');

	fmod.Api.create();

	master = Fmod.loadBankFile('Master.bank');
	master_strings = Fmod.loadBankFile('Master.strings.bank');
	sfx = Fmod.loadBankFile('SFX.bank');

	var event = Fmod.createEvent('event:/UI/Cancel');
	Fmod.startEvent(event);

	Thread.create(() -> {
		Fmod.update();
		Sys.sleep(0.04);
	});

	while (true) {}
}
```
