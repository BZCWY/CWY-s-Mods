package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0';
	public static var curSelected:Int = 0;
	var allowMouse:Bool = true;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = [
		'freeplay',
		'credits',
		'options'
	];
	var itemPositions:Array<{x:Float, y:Float}> = [
		{x: 700, y: 170},
		{x: 550, y: 200},
		{x: 1050, y: 550}
	];
	var itemsize:Array<Float> = [
		0.4,
		0.6,
		0.15
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var leftChar:FlxSprite;
	var optionTween:Array<FlxTween> = [];

	static var showOutdatedWarning:Bool = true;

	override function create()
	{
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.15;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('BG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width / 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var fnfbg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('FNFBG'));
		fnfbg.antialiasing = ClientPrefs.data.antialiasing;
		fnfbg.scrollFactor.set(0, yScroll);
		fnfbg.setGraphicSize(Std.int(bg.width / 1.2));
		fnfbg.updateHitbox();
		fnfbg.screenCenter();
		fnfbg.y -= 43;
		fnfbg.x += 20;
		add(fnfbg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var pos = itemPositions[i];
			var size = itemsize[i];
			createMenuItem(optionShit[i], pos.x, pos.y, size, i);
		}

		var psychVer:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('psychVer'));
		psychVer.frames = Paths.getSparrowAtlas('psychVer');
		psychVer.animation.addByPrefix('idle', 'idle', 24, true);
		psychVer.animation.addByPrefix('selected', 'selected', 24, true);
		psychVer.animation.play('idle');
		psychVer.antialiasing = ClientPrefs.data.antialiasing;
		psychVer.scrollFactor.set(0, yScroll);
		psychVer.setGraphicSize(Std.int(psychVer.width / 1.2));
		psychVer.updateHitbox();
		psychVer.screenCenter();
		psychVer.y -= 50;
		psychVer.x += 280;
		add(psychVer);

		var px:Int = -370;
		for (i in 0...2)
		{
			var WhiteBar:FlxSprite = new FlxSprite(-675, px).makeGraphic(FlxG.width * 2, 56, FlxColor.WHITE);
			add(WhiteBar);
			px = 310;
		}

		var chars = ["teto", "miku"];
		var selected = chars[Std.random(chars.length)];
		leftChar = new FlxSprite(50, FlxG.height/2);
		leftChar.loadGraphic(Paths.image(selected));
		leftChar.setGraphicSize(Std.int(leftChar.width / 2));
		leftChar.updateHitbox();
		//leftChar.screenCenter(Y);
		leftChar.y -= 608;
		leftChar.x -= 600;
		add(leftChar);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		#if CHECK_FOR_UPDATES
		if (showOutdatedWarning && ClientPrefs.data.checkForUpdates && substates.OutdatedSubState.updateVersion != psychEngineVersion) {
			persistentUpdate = false;
			showOutdatedWarning = false;
			openSubState(new substates.OutdatedSubState());
		}
		#end

		FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float, size:Float, i:Int):Void
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.scale.x = size;
		menuItem.scale.y = size;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
	
		//调了半天这玩意最后发现调不调没软用
		//menuItem.offset.set(menuItem.width / itemoffset[i].ox, menuItem.height / itemoffset[i].oy);
	
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
	}

	//NF的太好用了你们知道吗
	var selectedSomethin:Bool = false;
	var timeNotMoving:Float = 0;
	var usingMouse:Bool = true;
	var canClick:Bool = true;
	var endCheck:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);
			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse = this.allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed))
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var dist:Float = -1;
				var distItem:Int = -1;
				for (i in 0...optionShit.length)
				{
					var memb:FlxSprite = menuItems.members[i];
					if (memb == null || !memb.exists) continue;

					if (FlxG.mouse.overlaps(memb))
					{
						var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
						if (dist < 0 || distance < dist)
						{
							dist = distance;
							distItem = i;
							allowMouse = true;
						}
					}
				}

				if (distItem != -1 && menuItems.members[distItem] != menuItems.members[curSelected])
				{
					curSelected = distItem;
					changeItem();
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if (timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (usingMouse && canClick)
			{
				var overAny:Bool = false;
				var newHover:Int = -1;
				for (i in 0...menuItems.length)
				{
					var spr = menuItems.members[i];
					if (spr == null || !spr.exists) continue;

					if (FlxG.mouse.overlaps(spr))
					{
						overAny = true;
						newHover = i;
						if (FlxG.mouse.justPressed)
						{
							selectSomething();
							break;
						}
						//if (spr.animation.curAnim.name == 'idle')
						//{
							//FlxG.sound.play(Paths.sound('scrollMenu'));
							//spr.animation.play('selected');
						//}
					}
					//else
					//{
						//if (spr.animation.curAnim.name != 'idle')
							//spr.animation.play('idle');
					//}
				}
				if (overAny && newHover != -1 && newHover != curSelected)
				{
					curSelected = newHover;
					for (spr in menuItems)
					{
						if (spr == null || !spr.exists) continue;
						if (spr.ID != curSelected)
							spr.animation.play('idle');
					}
					changeItem(0);
				}
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				var item = menuItems.members[curSelected];
				var option = optionShit[curSelected];

				FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					if (item == null || !item.exists) return;

					switch (option)
					{
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());
						#if MODS_ALLOWED
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());
						#end
						#if ACHIEVEMENTS_ALLOWED
						case 'achievements':
							MusicBeatState.switchState(new AchievementsMenuState());
						#end
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
						case 'donate':
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
							selectedSomethin = false;
							item.visible = true;
						default:
							trace('Menu Item ${option} doesn\'t do anything');
							selectedSomethin = false;
							item.visible = true;
					}
				});

				for (memb in menuItems)
				{
					if (memb == item) continue;
					if (memb == null || !memb.exists) continue;
					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}

			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function selectSomething()
	{
		endCheck = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		canClick = false;
		selectedSomethin = true;
		FlxG.mouse.visible = false;

		if (ClientPrefs.data.flashing)
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);

		var item = menuItems.members[curSelected];
		var option = optionShit[curSelected];

		FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
		{
			if (item == null || !item.exists) return;

			switch (option)
			{
				case 'freeplay':
					MusicBeatState.switchState(new FreeplayState());
				#if MODS_ALLOWED
				case 'mods':
					MusicBeatState.switchState(new ModsMenuState());
				#end
				#if ACHIEVEMENTS_ALLOWED
				case 'achievements':
					MusicBeatState.switchState(new AchievementsMenuState());
				#end
				case 'credits':
					MusicBeatState.switchState(new CreditsState());
				case 'options':
					MusicBeatState.switchState(new OptionsState());
					OptionsState.onPlayState = false;
					if (PlayState.SONG != null)
					{
						PlayState.SONG.arrowSkin = null;
						PlayState.SONG.splashSkin = null;
						PlayState.stageUI = 'normal';
					}
				case 'donate':
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
					selectedSomethin = false;
					item.visible = true;
				default:
					trace('Menu Item ${option} doesn\'t do anything');
					selectedSomethin = false;
					item.visible = true;
			}
		});

		for (memb in menuItems)
		{
			if (memb == item) continue;
			if (memb == null || !memb.exists) continue;
			FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
		}
	}

	function changeItem(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			if (item == null || !item.exists) continue;
			item.animation.play('idle');
		}

		var selectedItem = menuItems.members[curSelected];
		if (selectedItem != null && selectedItem.exists)
		{
			selectedItem.animation.play('selected');
		}
	}
}