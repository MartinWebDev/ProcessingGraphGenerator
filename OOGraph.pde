// Main display properties
int scrWidth = 800;
int scrHeight = 500;
int screenPadding = 20;

// Graph variables
int[] graphValues = new int[10];
GraphPoint[] graphPoints = new GraphPoint[10];

// Graph display control
int graphPointSpacing = floor(scrWidth / (graphPoints.length + 1));

// Jitter
boolean addGraphNoise = false;
float xOffsetNoise = 0;

void settings() {
    // Setup window
    size(scrWidth, scrHeight);
}

void setup() {
    // Setup graph values
    newGraphValues();
}

void newGraphValues() {
    for (int i = 0; i < graphValues.length; i++) {
        graphValues[i] = floor(random(20, 300));
        
        // Get current, previous, and next
        java.lang.Integer curr = graphValues[i];
        java.lang.Integer prev = i == 0 ? null : graphValues[i - 1];
        java.lang.Integer next = i == graphValues.length - 1 ? null : graphValues[i + 1];
        
        graphPoints[i] = new GraphPoint(curr, prev, next);
    }
}

void mouseClicked() {
    //addGraphNoise = !addGraphNoise;
    newGraphValues();
}

void draw() {
    // Clear background
    background(50);

    // Draw axis lines then tranlate to that location ready for other drawing
    // In this project, values will just go down from the top of the screen to avoid having to negate all Y values
    pushMatrix();
    
    stroke(255);
    strokeWeight(2);
    line(screenPadding, screenPadding / 2, screenPadding, scrHeight - screenPadding);
    line(screenPadding / 2, screenPadding, scrWidth - screenPadding, screenPadding);
    
    translate(screenPadding, screenPadding);
    
    ///////////////////////////////
    // Draw all other stuff here //
    ///////////////////////////////
    
    // Draw all graph points (graph points draw their own control points)
    for (int i = 0; i < graphPoints.length; i++) {
        if (addGraphNoise) {
            graphPoints[i].UpdateGraphValue(round(graphPoints[i].CurrentGraphValue() + ((noise(xOffsetNoise) - 0.5) * 10)));
            
            xOffsetNoise += 0.1 * i;
        }
        
        graphPoints[i].Render(floor((graphPointSpacing * i) + graphPointSpacing)); 
    }
    
    // Draw bezier line between all points (exclude the end one as there is nothing to connect to)
    for (int i = 0; i < graphPoints.length - 1; i++) {
        // Start X
        int startX = floor((graphPointSpacing * i) + graphPointSpacing);
        
        // Start Y
        int startY = graphValues[i];
        
        // End X
        int endX = floor((graphPointSpacing * (i + 1)) + graphPointSpacing);
        
        // End Y
        int endY = graphValues[i + 1];
        
        // Control point 1
        PVector c1 = graphPoints[i].controlPointNext;
        
        // Control point 2
        PVector c2 = graphPoints[i + 1].controlPointPrev;
        
        // Draw line
        stroke(200);
        strokeWeight(2);
        noFill();
        bezier(startX, startY, c1.x, c1.y, c2.x, c2.y, endX, endY);
    }
    
    /////////////////////////////////////
    // End - Draw all other stuff here //
    /////////////////////////////////////
    
    popMatrix();
}