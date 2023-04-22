package funkin.editors.charter;

import funkin.backend.system.Conductor;

class CharterNoteGroup extends FlxTypedGroup<CharterNote> {
	var __loopSprite:CharterNote;
	var i:Int = 0;
	var max:Float = 0;
	var __currentlyLooping:Bool = false;

	public override function forEach(noteFunc:CharterNote->Void, recursive:Bool = false) {
		i = 0;
		__loopSprite = null;

		max = FlxG.height / 70 / camera.zoom;

		var oldCur = __currentlyLooping;
		__currentlyLooping = true;

		var curStep = Conductor.curStepFloat;
		if (FlxG.state is Charter && !FlxG.sound.music.playing)
			curStep = cast(FlxG.state, Charter).conductorFollowerSpr.y / 40;

		while(i < length) {
			__loopSprite = members[i];
			if (__loopSprite == null || !__loopSprite.exists) {
				i++;
				continue;
			}
			if (Math.abs(__loopSprite.step - curStep) - __loopSprite.susLength < max)
				noteFunc(__loopSprite);
			i++;
		}
		__currentlyLooping = oldCur;
	}

	public override function draw() {
		@:privateAccess var oldDefaultCameras = FlxCamera._defaultCameras;
		@:privateAccess if (cameras != null) FlxCamera._defaultCameras = cameras;

		forEach((n) -> n.draw());

		@:privateAccess FlxCamera._defaultCameras = oldDefaultCameras;
	}

	public override function update(elapsed:Float) {
		@:privateAccess var oldDefaultCameras = FlxCamera._defaultCameras;
		@:privateAccess if (cameras != null) FlxCamera._defaultCameras = cameras;

		forEach((n) -> n.update(elapsed));

		@:privateAccess FlxCamera._defaultCameras = oldDefaultCameras;
	}
}