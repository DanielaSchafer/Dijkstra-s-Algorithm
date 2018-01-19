import java.util.ArrayList;
import java.util.HashMap;

public class dijkstra {

	public static void main(String[] args) {

		//Creation of the Graph
		Node a = new Node("a",0); //0
		Node b = new Node("b",0); //1
		Node c = new Node("c",0); //2
		Node d = new Node("d",0); //3
		Node e = new Node("e",0); //4
		Node f = new Node("f",0); //5
		Node g = new Node("g",0); //6
		Node h = new Node("h",0); //7
		Node i = new Node("i",0); //8

		HashMap<String,Node> nodes = new HashMap<String,Node>();

		nodes.put(a.getLabel(),a);
		nodes.put(b.getLabel(),b);
		nodes.put(c.getLabel(),c);
		nodes.put(d.getLabel(),d);
		nodes.put(e.getLabel(),e);
		nodes.put(f.getLabel(),f);
		nodes.put(g.getLabel(),g);
		nodes.put(h.getLabel(),h);
		nodes.put(i.getLabel(),i);

		Edge ab = new Edge(a,b,4);
		Edge ag = new Edge(a,h,8);
		Edge bc = new Edge(b,c,8);
		Edge bg = new Edge(b,h,11);
		Edge cd = new Edge(c,d,7);
		Edge ci = new Edge(c,i,2);
		Edge cf = new Edge(c,f,4);
		Edge de = new Edge(d,e,9);
		Edge ef = new Edge(e,f,10);
		Edge df = new Edge(d,f,14);
		Edge fg = new Edge(f,g,2);
		Edge gh = new Edge(g,h,1);
		Edge hi = new Edge(h,i,7);
		Edge gi = new Edge(g,i,6);

		a.addNeighbor(ab);
		a.addNeighbor(ag);
		b.addNeighbor(bc);
		b.addNeighbor(bg);
		c.addNeighbor(cd);
		c.addNeighbor(ci);
		c.addNeighbor(cf);
		d.addNeighbor(de);
		d.addNeighbor(df);
		e.addNeighbor(ef);
		f.addNeighbor(fg);
		g.addNeighbor(gh);
		h.addNeighbor(hi);
		g.addNeighbor(gi);

		System.out.println(getShortestPaths(nodes,"a"));
	}

	public static HashMap<String,Integer> getShortestPaths(HashMap<String,Node> graph, String startingNode)
	{
		//the distance hm: where the shortest distance from each node to the starting node is stored
		HashMap<String,Integer> distances = new HashMap<String,Integer>();
		//keeps track of nodes already used
		HashMap<String, Node> found = new HashMap<String, Node>();

		//gives each node a distance of infinity (max integer)
		//except for the starting node, which gets a distance of 0
		for(String key : graph.keySet())
		{
			if(key.equals(startingNode))
				distances.put(key, 0);
			else
				distances.put(key,Integer.MAX_VALUE);
		}

		//uses a while loop to make sure to hit all the nodes once
		while(found.size()<graph.size())
		{
			//finds the node with the shortest distance, and that hasn't been accounted for
			String minNodeKey = pickMinDistance(found,graph,distances);
			Node minNode = graph.get(minNodeKey);
			//adds it to the hm of nodes that have been found
			found.put(minNodeKey, minNode);

			//gets neighboring edges of the minNode
			ArrayList<Edge> neighbors = minNode.getNeighbors();

			//changes the distance for each of the edges based off of the distance of the node and the weight of the edge
			//only if the new distance is shorter than the original distance
			for(int i = 0; i<neighbors.size(); i++)
			{
				//the distance from the starting node to the minNode + the weight of the edge
				int newDistance = neighbors.get(i).getWeight()+distances.get(minNodeKey);

				//checks to make sure that the edge hasn't been accounted for
				//by seeing if the new distance is less than the original distance of the node
				if(newDistance<distances.get(neighbors.get(i).getNeighbor(minNode).getLabel()))
				{
					distances.put(neighbors.get(i).getNeighbor(minNode).getLabel(), newDistance);
				}
			}
		}
		return distances;
	}

	//finds the next node with the shortest distance (cannot be a node already found)
	public static String pickMinDistance(HashMap<String, Node> nodesFound, HashMap<String,Node> graph, HashMap<String,Integer> distances)
	{
		String minKey = null;
		int minVal = -1;

		//sets variables to an available value
		for(String key : graph.keySet())
		{
			//checks if node is in nodesFound
			if(nodesFound.containsKey(key) == false)
			{
				minKey = key;
				minVal = distances.get(key);
			}
		}

		//finds shortest distance
		for(String key : graph.keySet())
		{
			//checks if node is in nodesFound
			if(nodesFound.containsKey(key) == false && distances.get(key)<minVal)
			{
				minKey = key;
				minVal = distances.get(key);
			}
		}
		return minKey;
	}

}
