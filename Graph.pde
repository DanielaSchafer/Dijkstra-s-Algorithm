PImage dino;
PImage grass;
PImage tree;

PFont treeName;
PFont treeDistance;

int stepNum;

void setup()
{
  size(1200, 800);
  background(255);

  treeName = createFont("Consolas", 35);
  treeDistance = createFont("Consolas", 25);

  dino = loadImage("dijkstra.png");
  grass = loadImage("dans_grass.png");
  tree = loadImage("tree.png");

  image(grass, 0, 0);

  PFont g = createFont("Bookman Old Style Italic", 20);
  textFont(g);
  text("Art by Sonia Fung", 1000, 780);

  stepNum = 1;
}


void draw()
{
}

void keyPressed()
{
  image(grass, 0, 0);
  System.out.println("pressed " +stepNum);
  present(stepNum);
  stepNum++;
}

public void present(int step)
{
  System.out.println("step "+step);
  ArrayList<Edge> edges = new ArrayList<Edge>();
  HashMap<String, Node> nodes = new HashMap<String, Node>();
  getNodeEdgeArrays(edges, nodes);

  if (step == 0)
    drawGraph(nodes, edges);
  else if (step<=nodes.size())
  {
    ArrayList<Node> found = getShortestPathsRoute(nodes, "a", edges, step);

    drawHighlightedGraph(nodes, edges, found, step);
    drawDino(found.get(found.size()-1));
  } else
  drawCompleteGraph(nodes, edges);
}

public void drawDino(Node n)
{
  image(dino, n.getX()-70, n.getY()+12);
}

public void drawNodes(Node[] nodes)
{
  for (int i = 0; i<nodes.length; i++)
  {
    drawNode(nodes[i]);
  }
}

public void drawNode(Node n)
{
  strokeWeight(1);
  stroke(0);

  //fill(50,200,100);
  //ellipse(n.getX(),n.getY(),50,50);
  image(tree, n.getX(), n.getY());
  fill(0);
  textFont(treeName);
  text(n.getLabel(), n.getX()+10, n.getY()-4);

  fill(22, 159, 242);
}

public void drawEdge(Edge e)
{
  strokeWeight(3);
  stroke(0);
  Node a = e.getOne();
  Node b = e.getTwo();
  line(a.getX()+25, a.getY()+65, b.getX()+25, b.getY()+65);
}

public void drawEdgeWithWeight(Edge e)
{
  strokeWeight(3);
  stroke(0);
  Node a = e.getOne();
  Node b = e.getTwo();
  line(a.getX()+25, a.getY()+65, b.getX()+25, b.getY()+65);

  textFont(treeDistance);
  noStroke();
  int midX = ((a.getX()+25)+(b.getX()+25))/2;
  int midY = ((a.getY()+65)+(b.getY()+65))/2;
  fill(172, 255, 49);
  if (e.getWeight()<10)
    rect(midX-3, midY-17, 20, 20, 5);
  else
    rect(midX-1, midY-17, 30, 20, 5);
  fill(0);
  text(e.getWeight(), midX, midY);
}

public void drawGEdge(Edge e)
{
 strokeWeight(3);
  stroke(255);
  Node a = e.getOne();
  Node b = e.getTwo();
  line(a.getX()+25, a.getY()+65, b.getX()+25, b.getY()+65);
}

public void drawGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges)
{
  for (int i = 0; i<edges.size(); i++)
  {
    drawEdge(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
  }
}

public void drawGraphWithWeight(HashMap<String, Node> nodes, ArrayList<Edge> edges)
{
  for (int i = 0; i<edges.size(); i++)
  {
    drawEdgeWithWeight(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
  }
}

public void drawHighlightedGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges, ArrayList<Node> found, int steps)
{
  HashMap<String, Integer> distances = getShortestPathsSteps(nodes, "a", steps);
  System.out.println(distances);
  for (int i = 0; i<edges.size(); i++)
  {
    if (found.contains(edges.get(i).getOne()) && found.contains(edges.get(i).getTwo()))
      drawGEdge(edges.get(i));
    else
      drawEdge(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
    if (found.contains(nodes.get(key)))
      drawNodeLabelFound(nodes.get(key), distances.get(key));
    else
      drawNodeLabel(nodes.get(key), distances.get(key));
  }
}

public void drawCompleteGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges)
{
  HashMap<String, Integer> distances = getShortestPaths(nodes, "a");
  for (int i = 0; i<edges.size(); i++)
  {
    drawEdgeWithWeight(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    Node n = nodes.get(key);
    int dist = distances.get(key);
    drawNode(n);
    drawNodeLabel(n, dist);
  }
}

public void drawNodeLabel(Node n, int dist)
{
  fill(22, 159, 242);
  if (dist == Integer.MAX_VALUE)
  {
    noStroke();
    ellipse(n.getX()+25, n.getY()+81, 29, 15);
    fill(0);
    text("∞", n.getX()+15, n.getY()+90);
  } else if (dist < 10)
  {
    textFont(treeDistance);
    noStroke();
    rect(n.getX()+15, n.getY()+73, 20, 20);
    fill(0);
    text(dist, n.getX()+18, n.getY()+90);
  } else
  {
    textFont(treeDistance);
    noStroke();
    rect(n.getX()+8, n.getY()+73, 34, 20);
    fill(0);
    text(dist, n.getX()+10, n.getY()+90);
  }
}

public void drawNodeLabelFound(Node n, int dist)
{
  fill(255, 190, 65);
  if (dist == Integer.MAX_VALUE)
  {
    noStroke();
    ellipse(n.getX()+25, n.getY()+81, 29, 15);
    fill(0);
    text("∞", n.getX()+15, n.getY()+90);
  } else if (dist < 10)
  {
    textFont(treeDistance);
    noStroke();
    rect(n.getX()+15, n.getY()+73, 20, 20);
    fill(0);
    text(dist, n.getX()+18, n.getY()+90);
  } else
  {
    textFont(treeDistance);
    noStroke();
    rect(n.getX()+8, n.getY()+73, 34, 20);
    fill(0);
    text(dist, n.getX()+10, n.getY()+90);
  }
}


public ArrayList<Node> getShortestPathsRoute(HashMap<String, Node> graph, String startingNode, ArrayList<Edge> edges, int steps)
{
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
  HashMap<String, Node> found = new HashMap<String, Node>();
  ArrayList<Node> route = new ArrayList<Node>();

  for (String key : graph.keySet())
  {
    if (key.equals(startingNode))
      distances.put(key, 0);
    else
      distances.put(key, Integer.MAX_VALUE);
  }

  while (found.size()<steps)
  {
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    found.put(minNodeKey, minNode);
    route.add(minNode);

    ArrayList<Edge> neighbors = minNode.getNeighbors();

    for (int i = 0; i<neighbors.size(); i++)
    {
      int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);
      if (newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
      {
        distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
      }
    }
  }
  System.out.println(route);
  return route;
}

public HashMap<String, Integer> getShortestPathsSteps(HashMap<String, Node> graph, String startingNode, int steps)
{
  //the distance hm: where the shortest distance from each node to the starting node is stored
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
  //keeps track of nodes already used
  HashMap<String, Node> found = new HashMap<String, Node>();

  for (String key : graph.keySet())
  {
    if (key.equals(startingNode))
      distances.put(key, 0);
    else
      distances.put(key, Integer.MAX_VALUE);
  }

  while (found.size()<steps)
  {
    //finds the node with the shortest distance, and that hasn't been accounted for
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    //adds it to the hm of nodes that have been found
    found.put(minNodeKey, minNode);

    //gets neighboring edges of the minNode
    ArrayList<Edge> neighbors = minNode.getNeighbors();

    //changes the distance for each of the edges based off of the distance of the node and the weight of the edge
    //only if the new distance is shorter than the original distance
    for (int i = 0; i<neighbors.size(); i++)
    {
      //the distance from the starting node to the minNode + the weight of the edge
      int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);

      //checks to make sure that the edge hasn't been accounted for
      //by seeing if the new distance is less than the original distance of the node
      if (newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
      {
        distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
      }
    }
  }
  return distances;
}

public HashMap<String, Integer> getShortestPaths(HashMap<String, Node> graph, String startingNode)
{
  //the distance hm: where the shortest distance from each node to the starting node is stored
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
  //keeps track of nodes already used
  HashMap<String, Node> found = new HashMap<String, Node>();

  //gives each node a distance of infinity (max integer)
  //except for the starting node, which gets a distance of 0
  for (String key : graph.keySet())
  {
    if (key.equals(startingNode))
      distances.put(key, 0);
    else
      distances.put(key, Integer.MAX_VALUE);
  }

  //uses a while loop to make sure to hit all the nodes once
  while (found.size()<graph.size())
  {
    //finds the node with the shortest distance, and that hasn't been accounted for
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    //adds it to the hm of nodes that have been found
    found.put(minNodeKey, minNode);

    //gets neighboring edges of the minNode
    ArrayList<Edge> neighbors = minNode.getNeighbors();

    //changes the distance for each of the edges based off of the distance of the node and the weight of the edge
    //only if the new distance is shorter than the original distance
    for (int i = 0; i<neighbors.size(); i++)
    {
      //the distance from the starting node to the minNode + the weight of the edge
      int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);

      //checks to make sure that the edge hasn't been accounted for
      //by seeing if the new distance is less than the original distance of the node
      if (newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
      {
        distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
      }
    }
  }
  return distances;
}

//finds the next node with the shortest distance (cannot be a node already found)
public static String pickMinDistance(HashMap<String, Node> nodesFound, HashMap<String, Node> graph, HashMap<String, Integer> distances)
{
  String minKey = null;
  int minVal = -1;

  //sets variables to an available value
  for (String key : graph.keySet())
  {
    //checks if node is in nodesFound
    if (nodesFound.containsKey(key) == false)
    {
      minKey = key;
      minVal = distances.get(key);
    }
  }

  //finds shortest distance
  for (String key : graph.keySet())
  {
    //checks if node is in nodesFound
    if (nodesFound.containsKey(key) == false && distances.get(key)<minVal)
    {
      minKey = key;
      minVal = distances.get(key);
    }
  }
  return minKey;
}


public void getNodeEdgeArrays(ArrayList<Edge> edges, HashMap<String, Node> nodes)
{
  Node a = new Node(200, 400, "a");
  Node b = new Node(300, 200, "b");
  Node c = new Node(400, 600, "c");
  Node d = new Node(500, 300, "d");
  Node e = new Node(600, 500, "e");
  Node f = new Node(700, 200, "f");
  Node g = new Node(800, 400, "g");
  Node h = new Node(900, 600, "h");
  Node i = new Node(1000, 400, "i");

  Edge ab = new Edge(a, b, 4);
  Edge ac = new Edge(a, c, 8);
  Edge bc = new Edge(b, c, 8);
  Edge bf = new Edge(b, f, 11);
  Edge cd = new Edge(c, d, 7);
  Edge ce = new Edge(c, e, 2);
  Edge ch = new Edge(c, h, 4);
  Edge de = new Edge(d, e, 9);
  Edge ef = new Edge(e, f, 10);
  Edge eh = new Edge(e, h, 3);
  Edge df = new Edge(d, f, 14);
  Edge fg = new Edge(f, g, 2);
  Edge gh = new Edge(g, h, 1);
  Edge hi = new Edge(h, i, 7);
  Edge gi = new Edge(g, i, 6);


  edges.add(ab);
  edges.add(ac);
  edges.add(bc);
  edges.add(bf);
  edges.add(cd);
  edges.add(ce);
  edges.add(ch);
  edges.add(de);
  edges.add(ef);
  edges.add(df);
  edges.add(fg);
  edges.add(gh);
  edges.add(hi);
  edges.add(gi);
  edges.add(eh);

  a.addNeighbor(ab);
  a.addNeighbor(ac);
  b.addNeighbor(bc);
  b.addNeighbor(bf);
  c.addNeighbor(cd);
  c.addNeighbor(ce);
  c.addNeighbor(ch);
  d.addNeighbor(de);
  d.addNeighbor(df);
  e.addNeighbor(ef);
  f.addNeighbor(fg);
  g.addNeighbor(gh);
  h.addNeighbor(hi);
  g.addNeighbor(gi);
  e.addNeighbor(eh);

  nodes.put(a.getLabel(), a);
  nodes.put(b.getLabel(), b);
  nodes.put(c.getLabel(), c);
  nodes.put(d.getLabel(), d);
  nodes.put(e.getLabel(), e);
  nodes.put(f.getLabel(), f);
  nodes.put(g.getLabel(), g);
  nodes.put(h.getLabel(), h);
  nodes.put(i.getLabel(), i);
}
