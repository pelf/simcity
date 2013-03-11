class Tile {
	int x, y;
	float z; // hills - for river simulation
	int kind;

	int progress = 1;
	float industry, residencial, comercial, mobility;
	float value, pollution, crime;

	void reset() {
			industry = 0;
			residencial = 0;
			comercial = 0;
			mobility = 0;
	}

	Tile(int x, int y) {
		this.x = x;
		this.y = y;
		this.kind = DIRT;
		this.z = 0;
	} 

	Tile(int x, int y, int k) {
		this.x = x;
		this.y = y;
		this.kind = k;
		this.z = 0;
	} 

	void draw() {
		float c;
		switch (draw_mode) {
			case 1: // MAP - for some reason processing is not letting me use a constant here :x
				// terrain
				fill(COLORS[this.kind]);
				rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
				
				// hills
				if (DRAW_HILLS && this.kind != WATER && this.z > 0) {
					c = 200 - this.z*10;
					fill( color(c,c/1.5,c/2, 50) );
					rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
				}
				break;

			case 3: // RESIDENTIAL - for some reason processing is not letting me use a constant here :x
				c = 200 - this.residencial*this.progress;
				fill( color(c/2,c/2,c));
				rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
				break;

			case 4: // INDUSTRY - for some reason processing is not letting me use a constant here :x
				c = 200 - this.industry*this.progress;
				fill( color(c,c/2,c/2));
				rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
				break;

			case 5: // COMERCIAL - for some reason processing is not letting me use a constant here :x
				c = 200 - this.comercial*this.progress;
				fill( color(c/2,c,c/2));
				rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
				break;
		}
	}

	void highlight() {
		fill(COLORS[currentTool]);
		rect(this.x*TILE_SIZE, this.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
	}

	boolean canBuild() {
		return this.kind == DIRT || this.kind == GRASS;
	}


}
