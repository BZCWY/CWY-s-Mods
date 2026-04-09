package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.utils.Assets;
import sys.io.File;

class CharacterSelectSubState extends MusicBeatSubstate
{
    var characters:Array<String> = [];
    var grpItems:FlxTypedGroup<FlxSprite>;
    var grpTexts:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;
    var onSelect:String->Void;

    public function new(onSelectCallback:String->Void)
    {
        super();
        onSelect = onSelectCallback;
    }

    override function create()
    {
        super.create();
        loadCharacterList();
        createUI();
        changeSelection();
    }

    function loadCharacterList()
    {
        var path = Paths.getText('c.txt');
        if (path != null)
        {
            var content = sys.io.File.getContent(path);
            characters = content.split('\n');
            for (i in 0...characters.length)
                characters[i] = characters[i].trim();
            characters = characters.filter(function(s) return s != "");
        }
        else
        {
            characters = ["teto"];
        }
    }

    function createUI()
    {
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
        add(bg);

        var panel = new FlxSprite(100, 100).makeGraphic(FlxG.width - 200, FlxG.height - 200, 0xFF222222);
        add(panel);

        var title = new FlxText(0, 120, 0, "Select Character", 32);
        title.screenCenter(X);
        title.y = 120;
        add(title);

        grpItems = new FlxTypedGroup<FlxSprite>();
        add(grpItems);
        grpTexts = new FlxTypedGroup<FlxText>();
        add(grpTexts);

        var startY:Float = 200;
        var spacing:Float = 70;
        for (i in 0...characters.length)
        {
            var icon = new FlxSprite(150, startY + i * spacing);
            var imgPath = 'characters/' + characters[i];
            if (Paths.fileExists('images/$imgPath.png', IMAGE))
                icon.loadGraphic(Paths.image(imgPath));
            else
                icon.loadGraphic(Paths.image('teto'));
            icon.setGraphicSize(64, 64);
            icon.updateHitbox();
            grpItems.add(icon);

            var text = new FlxText(230, startY + i * spacing + 20, 0, characters[i], 24);
            text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE);
            grpTexts.add(text);
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, characters.length - 1);
        for (i in 0...grpItems.length)
        {
            var item = grpItems.members[i];
            var txt = grpTexts.members[i];
            if (i == curSelected)
            {
                item.color = 0xFFFFFF;
                txt.color = 0xFFFF00;
            }
            else
            {
                item.color = 0x888888;
                txt.color = 0xCCCCCC;
            }
        }
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (controls.UI_UP_P)
            changeSelection(-1);
        if (controls.UI_DOWN_P)
            changeSelection(1);
        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            var selected = characters[curSelected];
            ClientPrefs.data.characterSelect = selected;
            ClientPrefs.saveSettings();
            if (onSelect != null)
                onSelect(selected);
            close();
        }
        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            close();
        }
    }
}