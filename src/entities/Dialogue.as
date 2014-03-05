/**
 * Created by zachwlewis on 2/22/14.
 */
package entities
{
import constants.Assets;
import constants.GC;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Tilemap;

public class Dialogue extends Entity
{
	private var _tilemap:Tilemap;
	private var _text:String;
	private var _characterIndex:uint = 0;
	private var _columnIndex:uint = 1;
	private var _rowIndex:uint = 2;
	private var _paused:Boolean = false;
	private var _textTick:uint = 0;
	private const TEXT_SPEED:uint = 5;

	public function Dialogue()
	{
		_tilemap = new Tilemap(Assets.MENU_SPRITES, 160, 48, 8, 8);
		_tilemap.x = 0;
		_tilemap.y = 96;
		_tilemap.scrollX = 0;
		_tilemap.scrollY = 0;
		
		// Set up frame.
		_tilemap.floodFill(0, 0, 0);
		// Corners
		_tilemap.setTile(0, 0, 1);
		_tilemap.setTile(_tilemap.columns - 1, 0, 2);
		_tilemap.setTile(0, _tilemap.rows - 1, 3);
		_tilemap.setTile(_tilemap.columns - 1, _tilemap.rows - 1, 4);
		// Borders
		_tilemap.setRect(1, 0, _tilemap.columns - 2, 1, 5);
		_tilemap.setRect(1, _tilemap.rows - 1, _tilemap.columns - 2, 1, 5);
		_tilemap.setRect(0, 1, 1, _tilemap.rows - 2, 6);
		_tilemap.setRect(_tilemap.columns - 1, 1, 1, _tilemap.rows - 2, 6);
		
		// Pause the dialogue until it has been initialized with text.
		_paused = true;
		
		super(0, 0, _tilemap);
	}

	public function resume():void
	{
		if (_paused)
		{
			if (_characterIndex >= _text.length)
			{
				world.recycle(this);
			}
			else
			{
				_tilemap.setRect(1, 1, _tilemap.columns - 2, _tilemap.rows - 2, 0);
				_columnIndex = 1;
				_rowIndex = 2;
				_paused = false;
				_textTick = 0;
			}
		}
	}
	
	public function init(text:String):void
	{
		_text = text;
		
		// Reset dialogue.
		_tilemap.setRect(1, 1, _tilemap.columns - 2, _tilemap.rows - 2, 0);
		_characterIndex = 0;
		_columnIndex = 1;
		_rowIndex = 2;
		
		// Begin dialogue.
		_paused = false;
	}

	override public function update():void
	{
		if (_textTick == 0 && !_paused && _characterIndex < _text.length)
		{
			_textTick = GC.TEXT_SPEED;
			var charCode:uint = _text.charCodeAt(_characterIndex);
			if (charCode == 10)
			{
				// New line.
				if (_rowIndex == 4)
				{
					// There is more dialog. Show the indicator and wait.
					_tilemap.setTile(_tilemap.columns - 2, _tilemap.rows - 2, 94);
					_paused = true;
				}
				else
				{
					_columnIndex = 1;
					_rowIndex += 2;
				}
			}
			else
			{
				if (_columnIndex < _tilemap.columns - 1)
				{
					_tilemap.setTile(_columnIndex, _rowIndex, charCode);
					_columnIndex++;
				}
			}
			_characterIndex++;
		}
		else if (_characterIndex >= _text.length)
		{
			_paused = true;
		}
		else
		{
			_textTick--;
		}
		super.update();
	}
}
}
