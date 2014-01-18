module wof.world;
import wof.mob;
import wof.vector2;
import std.random;

import allegro5.allegro;
import allegro5.allegro_primitives;
import std.stdio;

class World {
private:
	Mob[] mobs;
	Mob player;
public:
	void Init() {
		player = new Mob(this);
		player.Size = 10;
		player.Faction = 1;
		player.Color = ALLEGRO_COLOR(0, 0, 1, 1);
	}
	/* TODO: Basic behaviour, stats and abilities should all be the same for mob and player.
	 * Controllers outside them will be sending overriding commands for the few things you need to separate one type from the other.
	 * */
	void Handle_event(ALLEGRO_EVENT event) {
		switch(event.type) {
			case ALLEGRO_EVENT_MOUSE_BUTTON_DOWN: {
				player.Target_position = Vector2(event.mouse.x, event.mouse.y);
				player.Target_mob = null;
				foreach (m; mobs) {
					if((m.Position - player.Target_position).Length() < m.Size) {
						player.Target_mob = m;
					}
				}
				break;
			}
			default:
		}
	}
	
	Mob[] Get_area_mobs(Vector2 center, float radius) {
		return mobs;
	}

	void Update (float dt) {
		if(mobs.length < 10) {
			auto m = new Mob(this);
			m.Position = Vector2(uniform(0.0, 800.0), uniform(0.0, 600.0));
			m.Target_position = Vector2(uniform(0.0, 800.0), uniform(0.0, 600.0));
			m.Size = 10;
			mobs~= m;
		}

		foreach (ref m; mobs) {
			m.Update(dt);
		}
		
		player.Update(dt);
	}
	
	void Draw() const {
		foreach (m; mobs) {
			m.Draw();
		}
		player.Draw();
	}
}
