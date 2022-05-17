// data structures
float[][] adjacencyMatrix;
int[][] adjacencyMatrixIndices;

// initialization routine
void initializeActiveDataStructures() {
  activeNodes = new boolean[nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    activeNodes[i] = true;
  }
  activeEdges = new boolean[edgeCount];
  for (int i = 0; i < edgeCount; i++) {
    activeEdges[i] = true;
  }
}

void initializeAdjacencyMatrix() {
  adjacencyMatrix = new float[nodeCount][nodeCount];
  adjacencyMatrixIndices = new int[nodeCount][nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    for (int j = 0; j < nodeCount; j++) {
      adjacencyMatrix[i][j] = -1.0;
      adjacencyMatrixIndices[i][j] = -1;
    }
  }
  for(int i = 0; i < edgeCount; i++) {
    Edge e = edges[i];
    int from = e.getFromNode().getIndex();
    int to = e.getToNode().getIndex();
    adjacencyMatrix[from][to] = e.getMinutes();
    adjacencyMatrix[to][from] = e.getMinutes();
    adjacencyMatrixIndices[from][to] = i;
    adjacencyMatrixIndices[to][from] = i;
  }
}

// shortest path algorithm (Dijkstra's algorithm)
float shortestPath(int start, int end) {
  if (start == end) {
    for (int i = 0; i < nodeCount; i++) {
      activeNodes[i] = false;
    }
    activeNodes[start] = true;
    for (int i = 0; i < edgeCount; i++) {
      activeEdges[i] = false;
    } 
    return 0.0;
  }
  float[] distances = new float[nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    distances[i] = MAX_FLOAT;  
  }
  int[] prevVertices = new int[nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    prevVertices[i] = -1;
  }
  boolean[] visitedVertices = new boolean[nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    visitedVertices[i] = false; 
  }
  int visitedCount = 0;
  int currentVertex = start;
  distances[currentVertex] = 0.0;
  float minDist = MAX_FLOAT;
  while (visitedCount < nodeCount) {
    visitedVertices[currentVertex] = true;
    visitedCount++;
    for (int i = 0; i < nodeCount; i++) {
      if ( (!((adjacencyMatrix[currentVertex][i]) == -1.0)) && !(visitedVertices[i])) {
        distances[i] = distances[currentVertex] + adjacencyMatrix[currentVertex][i];
        prevVertices[i] = currentVertex;
      }
    }
    minDist = MAX_FLOAT;
    for (int i = 0; i < nodeCount; i++) {
      if (!(visitedVertices[i]) && (distances[i] < minDist)) {
        currentVertex = i;
        minDist = distances[i];
      }
    }
  }
  for (int i = 0; i < nodeCount; i++) {
    activeNodes[i] = false;
  }   
  for (int i = 0; i < edgeCount; i++) {
    activeEdges[i] = false;
  }
  // determine shortest path
  int startNode = end;
  int endNode = prevVertices[end];
  activeNodes[startNode] = true;
  activeNodes[endNode] = true;
  activeEdges[adjacencyMatrixIndices[startNode][endNode]] = true;
  while (endNode != start) {
    startNode = endNode;
    endNode = prevVertices[startNode];
    activeNodes[endNode] = true;
    activeEdges[adjacencyMatrixIndices[startNode][endNode]] = true;
  }
  return distances[end];
}
