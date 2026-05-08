package backend.animation;

import flixel.animation.FlxAnimationController;

class PsychAnimationController extends FlxAnimationController {
    public var followGlobalSpeed:Bool = true;
    static final MAX_ELAPSED:Float = 1.0 / 60.0;

    public override function update(elapsed:Float):Void {
		if (_curAnim != null) {
            var speed:Float = timeScale;
            if (followGlobalSpeed) speed *= FlxG.animationTimeScale;
            _curAnim.update(Math.min(elapsed, MAX_ELAPSED) * speed);
		}
		else if (_prerotated != null) {
			_prerotated.angle = _sprite.angle;
		}
	}
}
