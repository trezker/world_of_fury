module wof.skill;

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
	
	Skillstate state = COOLDOWN;
	float timer = 0;
	Vector2 target_position;
public:
	bool Is_ready() const @property {
		if(state == COOLDOWN && timer <= 0) {
			return true;
		}
		return false;
	}
	
	void Update(float dt) {
		if(timer > 0) {
			timer -= dt;
		}
		if(timer <= 0 && state == STRIKE) {
			timer = cooldowntime;
			state = COOLDOWN;
			//TODO: Execute skill effect
		}
	}
	
	void Draw() const {
		if(state == STRIKE) {
			al_draw_circle(target_position.x, target_position.y, radius, ALLEGRO_COLOR(1, 0, 0, 0.5), 1);
		} else if(state == COOLDOWN && timer > 0) {
			al_draw_circle(target_position.x, target_position.y, radius, ALLEGRO_COLOR(1, 0, 0, 1), 1);
		}
	}

	float cooldowntime = 1;
	float striketime = 1;
	float range = 10;
	float radius = 5;

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
