package worlds 
{
	import constants.Assets;
	import constants.Direction;
	import constants.GC;
	import entities.Actor;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class MapWorld extends World 
	{
		private var _player:Actor;
		private var _rawMapData:Class;
		private var _grid:Grid;
		private var _map:Tilemap;
		private var _mapEntity:Entity;
		
		public function MapWorld(map:Class) 
		{
			_rawMapData = map;
		}
		
		override public function begin():void 
		{
			generateMap(_rawMapData);
			_player = new Actor(2, 2, Direction.DOWN, GC.MOVE_SPEED, Assets.SPRITE_BLUE);
			add(_player);
			super.begin();
		}
		
		override public function update():void 
		{
			if (Input.check((Key.UP || Key.DOWN || Key.LEFT || Key.RIGHT) && Input.lastKey))
			{
				switch (Input.lastKey)
				{
					case Key.UP:
						_player.applyInput(Direction.UP);
						break;
					case Key.DOWN:
						_player.applyInput(Direction.DOWN);
						break;
					case Key.LEFT:
						_player.applyInput(Direction.LEFT);
						break;
					case Key.RIGHT:
						_player.applyInput(Direction.RIGHT);
						break;
					default:
						break;
				}
			}
			
			FP.camera.x = _player.x - 64;
			FP.camera.y = _player.y - 64;
			
			super.update();
		}
		
		public function getMap():Entity
		{
			return _mapEntity;
		}
		
		private function generateMap(data:Class):void
		{
			var xmlData:XML = FP.getXML(data);
			var mapWidth:uint = uint(xmlData.@width);
			var mapHeight:uint = uint(xmlData.@height);
			var tileString:String = xmlData.Tiles;
			var gridString:String = xmlData.Collision;
			
			// Populate Map
			_map = new Tilemap(Assets.MAP_TILES, mapWidth, mapHeight, GC.TILE_SIZE, GC.TILE_SIZE);
			_map.loadFromString(tileString);
			
			// Populate Grid
			_grid = new Grid(mapWidth, mapHeight, GC.TILE_SIZE, GC.TILE_SIZE);
			trace(gridString);
			_grid.loadFromString(gridString,"");
			
			_mapEntity = add(new Entity(0, 0, _map, _grid));
			_mapEntity.type = "maps";
		}
		
	}

}