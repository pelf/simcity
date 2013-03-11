int WORLD_SIZE = 40; // world is a WORLD_SIZExWORLD_SIZE grid 
int TILE_SIZE = 16; // each square of the grid has TILE_SIZE px each side  

int CANVAS_X = WORLD_SIZE*TILE_SIZE;
int CANVAS_Y = WORLD_SIZE*TILE_SIZE;

int STARTING_FUNDS = 10000;

Tile selectedTile, currentTile; // tile selected
int currentTool, funds, tick;
World world;
PImage toolbar;
ArrayList buildings;

void setup() {
	size(CANVAS_X, CANVAS_Y);
	frameRate(10);
	noStroke();

	toolbar = loadImage("toolbar.png");
	world = new World(WORLD_SIZE, WORLD_SIZE);
	currentTool = RESIDENTIAL;
	buildings = new ArrayList();
	funds = STARTING_FUNDS;
	tick = millis();
}

void draw() {
	// draw terrain
	world.draw();
	// UI
	if ((currentTile=world.getTileAt(mouseX,mouseY)) != null) {
		currentTile.highlight();
	}
	// toolbar
	image(toolbar, 0, 590);
	// funds
	fill(color(220,220,220));
	text("$ "+funds, 10, 20); 

	// TIME TICK - 1 sec
	if (millis() - tick > 5000) {
		tick();
		tick = millis();
	}
}

void tick() {
	println("TICK");
	world.reset();

	for(int i=0;i<buildings.size();i++) {
		world.influence((Tile)buildings.get(i));
	}
}

void mouseClicked() {
	//if (selectedTile != null)
	//	selectedTile.selected = false;
  //selectedTile = world.getTileAt(mouseX,mouseY);
  //selectedTile.selected = true;

	// BUILD !
  currentTile = world.getTileAt(mouseX,mouseY);
  if (currentTile.canBuild()){
  	currentTile.kind = currentTool;
  	buildings.add(currentTile);
  	funds -= ((Integer)costs.get(currentTool)).intValue();
  }
}

void keyReleased() {
	// tools
  if (key == 'r') {
  	currentTool = RESIDENTIAL;
  } else if (key == 'i') {
  	currentTool = INDUSTRY;
  } else if (key == 'c') {
  	currentTool = COMERCIAL;
  } else if (key == 'e') {
  	currentTool = POWER;
  }
  // draw mode
  else if (key == 'q')
  	draw_mode = MAP;
  else if (key == 'a')
  	draw_mode = RESIDENTIAL;
  else if (key == 'z')
  	draw_mode = INDUSTRY;
  else if (key == 'x')
  	draw_mode = COMERCIAL;
  

  println(currentTool);
}
