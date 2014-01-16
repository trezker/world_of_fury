module wof.mob;

import wof.vector2;
import allegro5.allegro;
import allegro5.allegro_primitives;
import wof.skill;

class Mob {
private:
	ALLEGRO_COLOR color = ALLEGRO_COLOR(1, 1, 1, 1);
	Vector2 position;
	Vector2 velocity;
	Vector2 target_position;
	Mob target_mob;
	float size = 1;
	int health = 1;
	int faction = 0;
	Skill skill;
public:
	void Update(float dt) {
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
	
	void Draw() const {
		al_draw_circle(Position.x, Position.y, Size, color, 1);
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

	Vector2 Target_position() const @property {
		return target_position;
	}
	
	void Target_position(Vector2 p) @property {
		target_position = p;
	}

	void Target_mob(Mob p) @property {
		target_mob = p;
	}
}
