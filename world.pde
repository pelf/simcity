boolean DRAW_HILLS = false;

int MAP = 1;
int draw_mode = MAP;

int DIRT = 0;
int GRASS = 1;
int WATER = 2;

int RESIDENTIAL = 3;
int INDUSTRY = 4;
int COMERCIAL = 5;
int POWER = 6;

color[] COLORS = new color[7];

HashMap costs = new HashMap();

class World {
	Tile[][] world;
	int width, height;

	World(int w, int h) {
		width = w;
		height = h;
		world = new Tile[w][h];

		// colors
		COLORS[DIRT] = #c69c6d;
		COLORS[GRASS] = #197b30;
		COLORS[WATER] = #0054a6;
		COLORS[RESIDENTIAL] = #002157;
		COLORS[INDUSTRY] = #9e0b0f;
		COLORS[COMERCIAL] = #005826;
		COLORS[POWER] = #fff200;

		costs.put(RESIDENTIAL, 50);
		costs.put(INDUSTRY, 100);
		costs.put(COMERCIAL, 150);
		costs.put(POWER, 300);

		generateTerrain();
	}

	void generateTerrain() {
		// dirt everywhere
		for(int i=0; i<this.width; i++)
			for(int j=0; j<this.height; j++)
				this.world[i][j] = new Tile(i,j);

		// grass
		int grassPatches = (int)random(3,6);
		println("grass patches: "+grassPatches);
		for(int i=0; i<grassPatches; i++) {
			int grassRadius = (int)random(5,9);
			println("grass patch #"+i+" radius: "+grassRadius);
			int[] center = {(int)random(grassRadius,this.width-grassRadius), (int)random(grassRadius,this.height-grassRadius)};
			// as we get farther from the center of the patch, the probability of having grass goes down
			for(int xi=max(0,center[0]-grassRadius); xi<min(this.width,center[0]+grassRadius); xi++) {
				for(int yi=max(0,center[1]-grassRadius); yi<min(this.height,center[1]+grassRadius); yi++) {
					float distProb = (1 - abs(xi-center[0])*(1.0/grassRadius)) + (1 - abs(yi-center[1])*(1.0/grassRadius));
					if (random(1.5) < distProb) {
						this.world[xi][yi].kind = GRASS;
					}
				}
			}
		}

		// hills
		int hills = (int)random(10,15);
		println("hills: "+hills);
		for(int i=0; i<hills; i++) {
			int hillRadius = (int)random(8,15);
			println("hill #"+i+" radius: "+hillRadius);
			int[] center = {(int)random(0,this.width), (int)random(0,this.height)};
			for(int xi=max(0,center[0]-hillRadius); xi<min(this.width,center[0]+hillRadius); xi++) {
				for(int yi=max(0,center[1]-hillRadius); yi<min(this.height,center[1]+hillRadius); yi++) {
					//hill is higher in the center
					// sqrt( (x2-x1)^2 + (y2-y1)^2) )
					this.world[xi][yi].z += max(0, hillRadius - sqrt(pow((center[0]-xi),2) + pow((center[1]-yi),2)));
				}
			}
		}

		// water :)
		for (int i = 0; i < 5; i++ )
			flow((int)random(0,this.width), (int)random(0,this.height));
		
	}

	// river generation
	void flow(int x, int y) {
		this.world[x][y].kind = WATER;

		if(random(1) < 0.8 && x+1 < this.width && y+1 < this.height && this.world[x+1][y+1].kind != WATER && this.world[x+1][y+1].z <= this.world[x][y].z)
			flow(x+1,y+1);
		if(random(1) < 0.7 && x+1 < this.width && this.world[x+1][y].kind != WATER && this.world[x+1][y].z <= this.world[x][y].z)
			flow(x+1,y);
		if(random(1) < 0.6 && y+1 < this.height && this.world[x][y+1].kind != WATER && this.world[x][y+1].z <= this.world[x][y].z)
			flow(x,y+1);
		if(random(1) < 0.5 && x-1 >= 0 && y+1 < this.height && this.world[x-1][y+1].kind != WATER && this.world[x-1][y+1].z <= this.world[x][y].z)
			flow(x-1,y+1);
		if(random(1) < 0.4 && x+1 < this.width && y-1 >= 0 && this.world[x+1][y-1].kind != WATER && this.world[x+1][y-1].z <= this.world[x][y].z)
			flow(x+1,y-1);
		if(random(1) < 0.4 && x-1 >= 0 && this.world[x-1][y].kind != WATER && this.world[x-1][y].z <= this.world[x][y].z)
			flow(x-1,y);
		if(random(1) < 0.4 && y-1 >= 0 && this.world[x][y-1].kind != WATER && this.world[x][y-1].z <= this.world[x][y].z)
			flow(x,y-1);
		if(random(1) < 0.4 && x-1 >= 0 && y-1 >= 0 && this.world[x-1][y-1].kind != WATER && this.world[x-1][y-1].z <= this.world[x][y].z)
			flow(x-1,y-1);
	}

	void draw() {
		for(int i=0; i<this.width; i++) {
			for(int j=0; j<this.height; j++) {
				// draw tiles
				this.world[i][j].draw();
			}
		}
	}

	Tile getTileAt(int x, int y) {
		x /= TILE_SIZE;
		y /= TILE_SIZE;
		if (x >= 0 && x < this.width && y >= 0 && y < this.height)
			return this.world[x][y];

		return null;
	}

	void reset() {
		for(int i=0; i<this.width; i++) {
			for(int j=0; j<this.height; j++) {
				this.world[i][j].reset();
			}
		}
	}

	void influence(Tile t) {
		int influenceRadius = 10;
		int influence = 1;
		for(int xi=max(0,t.x-influenceRadius); xi<min(this.width,t.x+influenceRadius); xi++) {
				for(int yi=max(0,t.y-influenceRadius); yi<min(this.height,t.y+influenceRadius); yi++) {
					// influence is higher in the center
					// sqrt( (x2-x1)^2 + (y2-y1)^2) )
					if (t.kind == INDUSTRY)
						this.world[xi][yi].industry += max(0, influenceRadius*influence - sqrt(pow((t.x-xi),2) + pow((t.y-yi),2))*influence);
					else if (t.kind == RESIDENTIAL)
						this.world[xi][yi].residencial += max(0, influenceRadius*influence - sqrt(pow((t.x-xi),2) + pow((t.y-yi),2))*influence);
					else if (t.kind == COMERCIAL)
						this.world[xi][yi].comercial += max(0, influenceRadius*influence - sqrt(pow((t.x-xi),2) + pow((t.y-yi),2))*influence);

					//this.world[xi][yi].mobility += max(0, influenceRadius*influence - sqrt(pow((t.x-xi),2) + pow((t.y-yi),2))*influence);
				}
			}
		
	}

}

