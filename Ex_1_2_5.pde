import processing.pdf.*;
//for Short path
boolean[] activeNodes;
boolean[] activeEdges;
Node A;
Node B;
int numOfNodes;
float numOfMinutes;

//color Effect
Integrator animateColor=new Integrator(100,0,70);

// nodes
int nodeCount; 
Node[] nodes = new Node[130];
HashMap nodeTable = new HashMap();

// selection
Node selection;

// record
boolean record; 

// edges
int edgeCount; 
Edge[] edges = new Edge[200];

// font
PFont font; 

void setup() {
  size(559, 559);
  font = createFont("SansSerif", 10);
  loadData();
  initializeActiveDataStructures();
  initializeAdjacencyMatrix();
}

void loadData() {
  Table connectionsTable = new Table("connections.csv");
  for (int i = 0;i < connectionsTable.getRowCount(); i++)
  {
    String fromPoint = connectionsTable.getString(i, 0);
    String toPoint = connectionsTable.getString(i, 1);
    String lineColor = connectionsTable.getString(i, 2); 
    float minutes = connectionsTable.getFloat(i, 3);
    
    if(i<28){
      lineColor = "r";
    }
    else if(i<45){
      lineColor = "o";
    }
    else if(i<110){
      lineColor = "g";
    }
    else{
      lineColor = "b";
    }
    addEdge(fromPoint, toPoint, minutes, lineColor);

  }
}

void addEdge(String fromLabel, String toLabel, float minutes, String col) {
  // find nodes
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);

  // old edge?
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      return;
    }
  }
  // add edge
  Edge e = new Edge(from, to, minutes, col);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}

Node findNode(String label) {
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}

Node addNode(String label) {
  Table nodesTable = new Table("locations.csv");
  int nodeIndex = nodesTable.getRowIndex(label);
  float x = nodesTable.getFloat(nodeIndex, 1);
  float y = nodesTable.getFloat(nodeIndex, 2); 
  Node n = new Node(label, x, y, nodeCount);
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n;
}

void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }

  textFont(font); 
  smooth();

  background(255); 

  // draw the edges
  for (int i = 0; i < edgeCount; i++) {
    if (activeEdges[i]){
      edges[i].draw(activeEdges[i]);
    }else{
      edges[i].draw(activeEdges[i]);
    }
  }


  // draw the nodes
  for (int i = 0; i < nodeCount; i++) {
    if (activeNodes[i]){
      nodes[i].draw(activeNodes[i]);
    }else{
      nodes[i].draw(activeNodes[i]);
    }
  }
  // display station name
  float closest = 5;
  for (int i = 0; i < nodeCount; i++) {
     Node n = nodes[i];
     float d = dist(mouseX, mouseY, n.x, n.y);
     if (d < closest) {
       selection = n;
       closest = d;
     }
  }
  if (selection != null) {
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text(selection.label, selection.x+4, selection.y+2);
  }
    
  // draw the text of short path
  if(numOfNodes==1){
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text("From:",10, 30);
    text(A.label, 55, 30);
  }
  if(numOfNodes==2){
    String travelTime  = nf(numOfMinutes,2,1);  //convert minute to 3 digital. step1.2.4
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text("From:",10, 30);
    text(A.label, 55, 30);
    text("To:",10, 50);
    text(B.label, 55, 50);
    textSize(16);
    text("Travel Time:",10, 70);
    text(travelTime, 120, 70);
    text("min",160, 70);
  }
  textSize(18);
  fill(50);
  text("MBTA TRAVEL TIME",5, 530);
    
  if (record) {
    endRecord();
    record = false;
  }
}
    


void mousePressed() {
  if (mouseButton == LEFT) {
    float closest = 5;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
  }
  
  //calculate the short path
  if (mouseButton == RIGHT) {
    float closest = 5;
    if(numOfNodes == 2){
      numOfNodes = 0;
      numOfMinutes = 0;
      initializeActiveDataStructures();
    }
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        if(numOfNodes == 0){
          A = n;
          numOfNodes++;
        }
        else if (numOfNodes == 1){
          B = n;
          numOfMinutes = shortestPath(A.getIndex(),B.getIndex());
          numOfNodes++;
        }
        
      }
    }
  }
}

/*void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}*/

void mouseReleased() {
  selection = null;
}

void keyPressed() {
  if (key == 'p') {
    record = true;
  }
}
