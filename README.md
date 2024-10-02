# HLFMOD

Haxe/HL bindings for FMOD Studio API

## How to use

### Getting started

To initialize FMOD, you need to call `Fmod.create`

```haxe
Fmod.create(36, FMOD_STUDIO_INIT_NORMAL, FMOD_INIT_NORMAL);
```

Then you need to load your master and master.strings banks

```haxe
Fmod.loadBankFile('Master.bank');
Fmod.loadBankFile('Master.strings.bank');
```
you can load the rest of the banks in the same way

### Getting event description

To get the event description, you need to call `Fmod.getEvent`

```haxe
var description:FmodEventDescription = Fmod.getEvent('YOUR_EVENT_PATH');
```
event path always starts with `event:/`

### Event instance control

After getting the event description, you can create an instance of this event using ```description.createInstance```

```haxe
var instance = description.createInstance();
```
