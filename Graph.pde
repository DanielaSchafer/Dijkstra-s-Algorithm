//DIJKSTRA THE DINOSAUR
//PRESS ANY KEY WITH A CORRESPONDING NODE LETTER TO DISPLAY THE SHORTEST PATH TO THAT NODE
//PRESS R TO RESTART
//PRESS Z TO GO THROUGH THE STEPS OF GETTING THE SHORTEST PATH TREE
//PRESS X TO DISPLAY SHORTEST PATH TREE

PImage dino;
PImage grass;
PImage tree;

PFont treeName;
PFont treeDistance;
PFont sonia;
PFont title;
PFont caption;
PFont authors;
PFont header;

static ArrayList<Edge> edges;
HashMap<String, Node> nodes;
String start;
color highlight;
GameState state;

int stepNum;

void setup()
{
  size(1200, 800);
  background(255);

  treeName = createFont("Consolas", 35);
  treeDistance = createFont("Consolas", 25);
  sonia = createFont("Bookman Old Style Italic", 20);
  title = createFont("Sylfaen", 30);
  caption = createFont("Sylfaen", 22);
  authors = createFont("Sylfaen", 18);
  header = createFont("Sylfaen", 24);

  dino = loadImage("dijkstra.png");
  grass = loadImage("dans_grass.png");
  tree = loadImage("tree.png");

  image(grass, 0, 0);

  textFont(sonia);
  text("Art by Sonia Fung", 1000, 780);

  start = "g";
  stepNum = -2;
  edges = new ArrayList<Edge>();
  nodes = new HashMap<String, Node>();
  getNodeEdgeArrays(edges, nodes);
  highlight = color(255, 0, 0);
  state = GameState.START;
}


void draw()
{
  if (state == GameState.START)
  {
    image(grass, 0, 0);
    textFont(title);
    fill(0);
    textAlign(CENTER);
    text("Dijkstra The Dinosaur", 600, 225);
    textFont(caption);
    text("Press 'enter' to view rules\nPress any key to play",600,280);
    image(dino, 560, 400);
    textFont(authors);
    text("Created by Daniela Schafer", 600, 550);
    text("Graphics by Sonia Fung", 600, 580);
    textFont(title);
  }
  if (state == GameState.STARTING_PAGE)
  {
    image(grass, 0, 0);
    drawGraphWithWeight(nodes, edges);
    textFont(title);
    fill(0);
    textAlign(CENTER);
    text("Pick a Starting Node", 600, 60);
    stepNum = 0;
  }
  if ( state == GameState.RULES)
  {
    image(grass, 0, 0);
    image(tree,580,170);
    textAlign(CENTER);
    textFont(title);
    text("Dijkstra The Dinosaur", 600, 300);
   textFont(header);
    text("How To Play:", 600, 350);
       textFont(caption);
    text("Use keyboard to pick nodes\nUse arrow keys to see step by step process of shortest path tree\nSelect node to get shortest path from starting node\nPress 'z' to view weights and distances\n Press 'x' to view shortest path tree\nPress 'r' to pick new starting node\nPress 'q' to return to homescreen", 600, 400);
  }
}

void keyPressed()
{
  if (state == GameState.START)
  {
    if (keyCode == ENTER)
      state = GameState.RULES;
    else
      state = GameState.STARTING_PAGE;
  } else if (state == GameState.RULES)
  {
    state = GameState.START;
  } else if (state == GameState.STARTING_PAGE)
  {
    if (key == 'q')
      state = GameState.START;
    if (nodes.containsKey(Character.toString(key)))
    {
      start = Character.toString(key);
      state = GameState.GAME;
      image(grass, 0, 0);
      drawGraphWithWeight(nodes, edges);
      drawDino(nodes.get(start));
    }
  } else if (state == GameState.GAME) {
    if (key == 'q')
      state = GameState.START;
    System.out.println(stepNum);
    image(grass, 0, 0);
    if (key == 'r')
    {
      state = GameState.STARTING_PAGE;
    } else if (nodes.containsKey(Character.toString(key)))
    {
      String keyVal = Character.toString(key);
      drawHighlightedPath(nodes, start, keyVal);
      drawDino(nodes.get(keyVal));
      stepNum = 0;
    } else if (keyCode == RIGHT)
    {
      System.out.println("pressed " +stepNum);
      present(stepNum, start);
      if (stepNum<nodes.size())
        stepNum++;
    } else if (keyCode == LEFT)
    {
      System.out.println("pressed " +stepNum);
      present(stepNum, start);
      if (stepNum>=0)
        stepNum--;
    } else if (key == 'x')
    {
      drawStPGraph(nodes, start);
      drawDino(nodes.get(start));
    } else if (key == 'z')
    {
      drawCompleteGraph(nodes, edges,start);
    } else
      present(stepNum, start);
  }
}

public void present(int step, String start)
{
  if (step <-1)
  {
    drawGraphWithWeight(nodes, edges);
    drawDino(nodes.get(start));
  } else if (step <0)
  {
    drawGraphWithWeight(nodes, edges);
    drawDino(nodes.get(start));
  } else if (step<1)
  {
    drawStartingGraph(nodes, edges, start);
    drawDino(nodes.get(start));
  } else if (step<=nodes.size())
  {
    ArrayList<Node> found = getShortestPathsRoute(nodes, start, edges, step);

    drawHighlightedGraph(nodes, edges, found, step, start);
    drawDino(nodes.get(start));
  } else
  drawCompleteGraph(nodes, edges,start);
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
  textAlign(LEFT);
  strokeWeight(1);
  stroke(0);
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
  textAlign(LEFT);
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

public void drawColorEdgeWithWeight(Edge e)
{
  textAlign(LEFT);
  strokeWeight(3);
  stroke(highlight);
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

public void drawUsedEdge(Edge e)
{
  strokeWeight(3);
  stroke(highlight);
  Node a = e.getOne();
  Node b = e.getTwo();
  line(a.getX()+25, a.getY()+65, b.getX()+25, b.getY()+65);
}

public void drawPathEdge(Edge e) {
  strokeWeight(3);
  stroke(255, 173, 41);
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

public void drawStartingGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges, String start)
{
  for (int i = 0; i<edges.size(); i++)
  {
    drawEdgeWithWeight(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
    if (key.equals(start))
      drawNodeLabel(nodes.get(key), 0);
    else
      drawNodeLabel(nodes.get(key), Integer.MAX_VALUE);
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

public void drawHighlightedGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges, ArrayList<Node> found, int steps, String start)
{
  HashMap<String, Integer> distances = getShortestPathsSteps(nodes, start, steps);
  HashMap<String, ArrayList<Edge>> paths = getShortestPathTreeSteps(nodes, start, steps);
  ArrayList<Edge> usedEdges = getSptEdges(paths);
  ArrayList<Edge> neighborsOfCurrNode = getEdgesOfFoundNodes(found);

  for (int i = 0; i<edges.size(); i++)
  {
    Edge e = edges.get(i);
    if (usedEdges.contains(e))
      drawUsedEdge(e);
    else if (neighborsOfCurrNode.contains(e))
    {
      if (!(found.contains(e.getOne()) && found.contains(e.getTwo())))
        drawEdgeWithWeight(e);
      else
        drawEdge(e);
    } else
      drawEdge(e);
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

public void drawHighlightedPath(HashMap<String, Node> nodes, String start, String end)
{
  HashMap<String, Integer> distances = getShortestPaths(nodes, start);
  HashMap<String, ArrayList<Edge>> spTree = getShortestPathTree(nodes, start);
  ArrayList<Edge> usedEdges = spTree.get(end);
  ArrayList<Node> nodesInPath = getNodesInPath(usedEdges);

  for (int i = 0; i<edges.size(); i++)
  {
    if (usedEdges.contains(edges.get(i)))
      drawColorEdgeWithWeight(edges.get(i));
    else
      drawEdgeWithWeight(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
    if (nodes.get(key).getLabel().equals(end) || nodes.get(key).getLabel().equals(start))
      drawNodeLabelFound(nodes.get(key), distances.get(key));
    else if (nodesInPath.contains(nodes.get(key)))
      drawNodeLabel(nodes.get(key), distances.get(key));
  }
}

public void drawCompleteGraph(HashMap<String, Node> nodes, ArrayList<Edge> edges,String start)
{
  HashMap<String, Integer> distances = getShortestPaths(nodes, start);
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

public void drawStPGraph(HashMap<String, Node> nodes, String start)
{
  HashMap<String, ArrayList<Edge>> spTree = getShortestPathTree(nodes, start);
  ArrayList<Edge> usedEdges = getSptEdges(spTree);
  HashMap<String, Integer> distances = getShortestPaths(nodes, start);

  for (int i = 0; i<edges.size(); i++)
  {
    if (usedEdges.contains(edges.get(i)))
      drawColorEdgeWithWeight(edges.get(i));
    else
      drawEdge(edges.get(i));
  }
  for (String key : nodes.keySet())
  {
    drawNode(nodes.get(key));
    drawNodeLabel(nodes.get(key), distances.get(key));
  }
}

public void drawNodeLabel(Node n, int dist)
{
  textAlign(LEFT);
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
  textAlign(LEFT);
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

public static ArrayList<Edge> getSptEdges(HashMap<String, ArrayList<Edge>> paths)
{
  ArrayList<Edge> usedEdges = new ArrayList<Edge>();
  for (String key : paths.keySet())
  {
    for (int i = 0; i<paths.get(key).size(); i++)
    {
      if (!usedEdges.contains(paths.get(key).get(i)))
        usedEdges.add(paths.get(key).get(i));
    }
  }
  return usedEdges;
}

public static ArrayList<Node> getNodesInPath(ArrayList<Edge> edges)
{
  ArrayList<Node> nodes = new ArrayList<Node>();
  for (int i = 0; i<edges.size(); i++)
  {
    Node one = edges.get(i).getOne();
    Node two = edges.get(i).getTwo();
    if (nodes.contains(one))
      nodes.add(one);
    else if (nodes.contains(two))
      nodes.add(two);
  }
  return nodes;
}

public static ArrayList<Edge> getEdgesOfFoundNodes(ArrayList<Node> found)
{
  ArrayList<Edge> e = new ArrayList<Edge>();
  for (int i = 0; i<found.size(); i++)
  {
    ArrayList<Edge> newE = found.get(i).getNeighbors();
    for (int j = 0; j<newE.size(); j++)
    {
      if (!e.contains(newE.get(j)))
      {
        e.add(newE.get(j));
      }
    }
  }
  for (int i = 0; i<e.size(); i++)
  {
    if (found.contains(e.get(i).getOne()) && found.contains(e.get(i).getTwo()))
      e.remove(i);
  }
  return e;
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
  return route;
}

public HashMap<String, Integer> getShortestPathsSteps(HashMap<String, Node> graph, String startingNode, int steps)
{
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
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
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    found.put(minNodeKey, minNode);

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
  return distances;
}

public HashMap<String, Integer> getShortestPaths(HashMap<String, Node> graph, String startingNode)
{
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
  while (found.size()<graph.size())
  {
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    found.put(minNodeKey, minNode);
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
  return distances;
}

public static HashMap<String, ArrayList<Edge>> getShortestPathTree(HashMap<String, Node> graph, String start)
{
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
  HashMap<String, ArrayList<Edge>> path = new HashMap<String, ArrayList<Edge>>();

  HashMap<String, Node> found = new HashMap<String, Node>();

  for (String key : graph.keySet())
  {
    if (key.equals(start)) {
      distances.put(key, 0);
      ArrayList<Edge> newPath = new ArrayList<Edge>();
      path.put(key, newPath);
    } else
      distances.put(key, Integer.MAX_VALUE);
  }
  while (found.size()<graph.size())
  {
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    found.put(minNodeKey, minNode);

    ArrayList<Edge> neighbors = minNode.getNeighbors();

    for (int i = 0; i<neighbors.size(); i++)
    {
      int checkingDistance = distances.get(neighbors.get(i).getNeighbor(minNode).getLabel())+neighbors.get(i).getWeight();
      int minNodeDistance = distances.get(minNodeKey);

      if (checkingDistance == minNodeDistance)
      {
        ArrayList<Edge> newPath = new ArrayList<Edge>();
        newPath.addAll(path.get(neighbors.get(i).getNeighbor(minNode).getLabel()));
        newPath.add(neighbors.get(i));
        path.put(minNodeKey, newPath);
      }
    }

    for (int i = 0; i<neighbors.size(); i++)
    {
      int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);

      if (newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
      {
        distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
      }
    }
  }
  return path;
}

public static HashMap<String, ArrayList<Edge>> getShortestPathTreeSteps(HashMap<String, Node> graph, String start, int step)
{
  HashMap<String, Integer> distances = new HashMap<String, Integer>();
  HashMap<String, ArrayList<Edge>> path = new HashMap<String, ArrayList<Edge>>();

  HashMap<String, Node> found = new HashMap<String, Node>();

  for (String key : graph.keySet())
  {
    if (key.equals(start)) {
      distances.put(key, 0);
      ArrayList<Edge> newPath = new ArrayList<Edge>();
      path.put(key, newPath);
    } else
      distances.put(key, Integer.MAX_VALUE);
  }
  while (found.size()<step)
  {
    String minNodeKey = pickMinDistance(found, graph, distances);
    Node minNode = graph.get(minNodeKey);
    found.put(minNodeKey, minNode);

    ArrayList<Edge> neighbors = minNode.getNeighbors();

    for (int i = 0; i<neighbors.size(); i++)
    {
      int checkingDistance = distances.get(neighbors.get(i).getNeighbor(minNode).getLabel())+neighbors.get(i).getWeight();
      int minNodeDistance = distances.get(minNodeKey);

      if (checkingDistance == minNodeDistance)
      {
        ArrayList<Edge> newPath = new ArrayList<Edge>();
        newPath.addAll(path.get(neighbors.get(i).getNeighbor(minNode).getLabel()));
        newPath.add(neighbors.get(i));
        path.put(minNodeKey, newPath);
      }
    }

    for (int i = 0; i<neighbors.size(); i++)
    {
      int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);

      if (newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
      {
        distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
      }
    }
  }
  return path;
}

public static String pickMinDistance(HashMap<String, Node> nodesFound, HashMap<String, Node> graph, HashMap<String, Integer> distances)
{
  String minKey = null;
  int minVal = -1;

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
  Node a = new Node(200, 375, "a");
  Node b = new Node(300, 175, "b");
  Node c = new Node(400, 575, "c");
  Node d = new Node(500, 275, "d");
  Node e = new Node(600, 475, "e");
  Node f = new Node(700, 175, "f");
  Node g = new Node(800, 375, "g");
  Node h = new Node(900, 575, "h");
  Node i = new Node(1000, 375, "i");

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

  b.addNeighbor(ab);
  c.addNeighbor(ac);
  c.addNeighbor(bc);
  f.addNeighbor(bf);
  d.addNeighbor(cd);
  e.addNeighbor(ce);
  h.addNeighbor(ch);
  e.addNeighbor(de);
  f.addNeighbor(df);
  f.addNeighbor(ef);
  g.addNeighbor(fg);
  h.addNeighbor(gh);
  i.addNeighbor(hi);
  i.addNeighbor(gi);
  h.addNeighbor(eh);

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
