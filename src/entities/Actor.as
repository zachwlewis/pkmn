package entities 
{
	import constants.Assets;
	import constants.Direction;
	import constants.GC;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Key;
	import worlds.MapWorld;
	
	/**
	 * ...
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Actor extends Entity 
	{
		protected var _sprite:Spritemap;
		protected var _facing:String;
		protected var _spriteIndex:uint;
		protected var _location:Point;
		protected var _canMove:Boolean = true;
		protected var _motion:MultiVarTween;
		protected var _speed:uint;
		protected var _hitbox:Hitbox;
		
		public function get facing():String { return _facing; }
		
		public function Actor(tileX:uint = 0, tileY:uint = 0, facing:String = "down", speed:uint = 0, sprite:uint = 0) 
		{
			_sprite = new Spritemap(Assets.CHARACTER_SPRITES, 16, 16, null);
			
			// Shift sprite up by 4 pixels to provide proper perspective.
			_sprite.y = -4;
			
			// Set up hitbox.
			_hitbox = new Hitbox(12, 12, 2, 2);
			
			_location = new Point(tileX, tileY);
			
			// Set the Actor's sprite.
			_spriteIndex = 6 * sprite;
			
			// Set the Actor's move speed.
			_speed = speed == 0 ? GC.MOVE_SPEED : speed;
			
			// Set the Actor's graphic and animation speed.
			_sprite.add(Direction.UP, [_spriteIndex + 3, _spriteIndex + 2], 2 / _speed, false);
			_sprite.add(Direction.DOWN, [_spriteIndex + 1, _spriteIndex + 0], 2 / _speed, false);
			_sprite.add(Direction.LEFT, [_spriteIndex + 5, _spriteIndex + 4], 2 / _speed, false);
			_sprite.add(Direction.RIGHT, [_spriteIndex + 5, _spriteIndex + 4], 2 / _speed, false);
			
			// Set the actor's initial facing.
			setFacing(facing);
			
			// Add the movement tween.
			_motion = new MultiVarTween(onMovementComplete, Tween.PERSIST);
			addTween(_motion, false);
			
			type = "actor";
			
			// Set the Entity's location and graphic.
			super(GC.TILE_SIZE * tileX, GC.TILE_SIZE * tileY, _sprite, _hitbox);
		}
		
		protected function onMovementComplete():void
		{
			_canMove = true;
		}
		
		protected function setFacing(facing:String):void
		{
			_facing = facing;
			_sprite.play(_facing, true, 1);
			_sprite.flipped = _facing == Direction.RIGHT;
		}
		
		public function applyInput(input:String):void
		{
			if (_canMove)
			{
				if (input != _facing)
				{
					setFacing(input);
				}

				var nextStep:Point = _location.add(Direction.GetDirectionValue(_facing));
				var worldStep:Point = nextStep.clone();
				worldStep.x *= GC.TILE_SIZE;
				worldStep.y *= GC.TILE_SIZE;
				
				var map:Entity = MapWorld(world).getMap();
				
				// Check for possible movement.
				if (worldStep.x >= 0 && worldStep.y >= 0 && worldStep.x < map.width && worldStep.y < map.height && !collideTypes(["maps", "actor"], worldStep.x, worldStep.y))
				{
					// Move one tile.
					_location = nextStep;
					
					if (_facing == Direction.UP || _facing == Direction.DOWN)
					{
						// Handle shuffle with a two frame walk cycle.
						_sprite.flipped = !_sprite.flipped;
					}
					
					_sprite.play(input, true);
					_motion.tween(this, { x:_location.x * GC.TILE_SIZE, y:_location.y * GC.TILE_SIZE }, _speed);
					_motion.start();
					_canMove = false;
				}
				
			}
			else
			{
				// Drop input.
			}
		}
	}

}