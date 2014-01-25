module wof.mob;

import wof.vector2;
import allegro5.allegro;
import allegro5.allegro_primitives;
import wof.skill;
import wof.world;
import std.stdio;
import std.conv;

class Mob {
private:
	ALLEGRO_COLOR color = ALLEGRO_COLOR(1, 1, 1, 1);
	Vector2 position;
	Vector2 velocity;
	Vector2 target_position;
	Mob target_mob;
	float size = 1;
	int health = 1;
	int max_health = 1;
	float health_regen = 0;
	float health_regen_rate = 1;
	int faction = 0;
	Skill skill;
	World world;
public:
	this(World w) {
		world = w;
		skill = new Skill;
		skill.Owner = this;
	}

	void Update(float dt) {
		if(health <= 0) {
			return;
		}
		
		if(health < max_health) {
			health_regen += health_regen_rate * dt;
			if(health_regen > 1) {
				health += to!int(health_regen);
				health_regen -= to!int(health_regen);
			}
		}
		
		if(skill.Allows_moving) {
			if(target_mob) {
				target_position = target_mob.Position;
			}

			Vector2 targetvector = target_position - position;
			if(targetvector.Length < 1 || (target_mob !is null && targetvector.Length < target_mob.Size + size)) {
				velocity = Vector2(0,0);
			} else {
				velocity = targetvector.Normalized * 100;
			}
			
			position += velocity * dt;
		}
		
		if(skill.Is_ready) {
			if(target_mob !is null && target_mob.Health <= 0)
				target_mob = null;
			
			if(target_mob is null) {
				Mob[] mobs = world.Get_area_mobs(position, size + skill.Range);
				foreach(m; mobs) {
					if(m is this)
						continue;
					if(m.Faction == faction)
						continue;
					if(m.Health <= 0)
						continue;
					skill.Target = m;
					if(skill.In_range) {
						target_mob = m;
						break;
					}
				}
			}
			
			if(target_mob !is null) {
				skill.Target = target_mob;
				if(skill.In_range) {
					skill.Apply();
				}
			}
		}
		skill.Update(dt);
	}
	
	void Draw() const {
		if(health > 0) {
			al_draw_circle(Position.x, Position.y, Size, color, 1);
			skill.Draw();
		}
		else
			al_draw_circle(Position.x, Position.y, Size, ALLEGRO_COLOR(0, 0, 0, 1), 1);
	}

	Vector2 Position() const @property {
		return position;
	}
	
	void Position(Vector2 p) @property {
		position = p;
	}

	void Color(ALLEGRO_COLOR p) @property {
		color = p;
	}
	
	float Size() const @property {
		return size;
	}
	
	void Size(float s) @property {
		size = s;
	} 

	int Faction() const @property {
		return faction;
	}
	
	void Faction(int s) @property {
		faction = s;
	} 

	int Health() const @property {
		return health;
	}
	
	void Health(int s) @property {
		health = s;
	}

	int Max_health() const @property {
		return max_health;
	}
	
	void Max_health(int s) @property {
		max_health = s;
	}

	float Health_regen_rate() const @property {
		return health_regen_rate;
	}
	
	void Health_regen_rate(float s) @property {
		health_regen_rate = s;
	}

	Vector2 Target_position() const @property {
		return target_position;
	}
	
	void Target_position(Vector2 p) @property {
		target_position = p;
	}

	void Target_mob(Mob p) @property {
		target_mob = p;
		skill.Interrupt();
	}
}
