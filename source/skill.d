module wof.skill;

import wof.mob;
import wof.vector2;
import allegro5.allegro;
import allegro5.allegro_primitives;
import std.stdio;

enum Skillstate {
	COOLDOWN,
	STRIKE
}

class Skill {
private:
	float cooldowntime = 1;
	float striketime = 1;
	float range = 10;
	float radius = 5;
	
	Skillstate state = Skillstate.COOLDOWN;
	float timer = 0;
	Mob target;
	Mob owner;
	Vector2 strike_point;
public:
	bool Is_ready() const @property {
		if(state == Skillstate.COOLDOWN && timer <= 0) {
			return true;
		}
		return false;
	}
	
	bool In_range() const @property {
		if(target is null)
			return false;
		float d = (target.Position - owner.Position).Length;
		if(d <= range + owner.Size) {
			return true;
		}
		return false;
	}
	
	void Apply() {
		if(!Is_ready)
			return;
		if(In_range) {
			strike_point = target.Position;
		} else {
			Vector2 d = target.Position - owner.Position;
			d.Normalize();
			d *= range;
			strike_point = owner.Position + d;
		}
		timer = striketime;
		state = Skillstate.STRIKE;
	}
	
	void Update(float dt) {
		if(timer > 0) {
			timer -= dt;
		}
		if(timer <= 0 && state == Skillstate.STRIKE) {
			timer = cooldowntime;
			state = Skillstate.COOLDOWN;
			//TODO: Execute skill effect
		}
	}
	
	void Draw() const {
		if(state == Skillstate.STRIKE) {
			al_draw_circle(strike_point.x, strike_point.y, radius, ALLEGRO_COLOR(1, 0, 0, 0.5), 1);
		} else if(state == Skillstate.COOLDOWN && timer > 0) {
			al_draw_filled_circle(strike_point.x, strike_point.y, radius, ALLEGRO_COLOR(1, 0, 0, 1));
		}
	}

	void Target(Mob s) @property {
		target = s;
	} 

	Mob Owner() @property {
		return owner;
	}

	void Owner(Mob s) @property {
		owner = s;
	}

	float Cooldowntime() const @property {
		return cooldowntime;
	}
	
	void Cooldowntime(float s) @property {
		cooldowntime = s;
	} 

	float Striketime() const @property {
		return striketime;
	}
	
	void Striketime(float s) @property {
		striketime = s;
	} 

	float Range() const @property {
		return range;
	}
	
	void Range(float s) @property {
		range = s;
	} 

	float Radius() const @property {
		return radius;
	}
	
	void Radius(float s) @property {
		radius = s;
	} 
}
