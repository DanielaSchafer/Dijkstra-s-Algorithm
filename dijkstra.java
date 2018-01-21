import java.util.ArrayList;
import java.util.HashMap;

public class dijkstra {

	public static void main(String[] args) {

		HashMap<String,Node> nodes = new HashMap<String,Node>();

		Node a = new Node("a");
		Node b = new Node("b");
		Node c = new Node("c");
		Node d = new Node("d");
		Node e = new Node("e");
		Node f = new Node("f");
		Node g = new Node("g");
		Node h = new Node("h");
		Node i = new Node("i");

		Edge ab = new Edge(a, b, 4);
		Edge ac = new Edge(a, c, 8);
		Edge bc = new Edge(b, c, 8);
		Edge bf = new Edge(b, f, 11);
		Edge cd = new Edge(c, d, 7);
		Edge ce = new Edge(c, e, 2);
		Edge ch = new Edge(c, h, 4);
		Edge de = new Edge(d, e, 9);
		Edge ef = new Edge(e, f, 10);
		Edge eh = new Edge(e,h,3);
		Edge df = new Edge(d, f, 14);
		Edge fg = new Edge(f, g, 2);
		Edge gh = new Edge(g, h, 1);
		Edge hi = new Edge(h, i, 7);
		Edge gi = new Edge(g, i, 6);


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

		System.out.println(getShortestPathTree(nodes,"a"));
	}

	//finds the shortest path from the starting node to each node
	public static HashMap<String,Integer> getShortestPathTree(HashMap<String,Node> graph, String startingNode)
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
			System.out.println(minNode);
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
			System.out.println(distances);
		}
		return distances;
	}


	public static HashMap<String,ArrayList<Edge>> getShortestPaths(HashMap<String,Node> graph,String start)
	{
		//the distance hm: where the shortest distance from each node to the starting node is stored
		HashMap<String,Integer> distances = new HashMap<String,Integer>();
		HashMap<String,ArrayList<Edge>> path = new HashMap<String,ArrayList<Edge>>();

		//keeps track of nodes already used
		HashMap<String, Node> found = new HashMap<String, Node>();

		//gives each node a distance of infinity (max integer)
		//except for the starting node, which gets a distance of 0
		for(String key : graph.keySet())
		{
			if(key.equals(start)) {
				distances.put(key, 0);
				ArrayList<Edge> newPath = new ArrayList<Edge>();
				path.put(key,newPath);
			}
			else
				distances.put(key,Integer.MAX_VALUE);
		}

		//uses a while loop to make sure to hit all the nodes once
		while(found.size()<graph.size())
		{
			//finds the node with the shortest distance, and that hasn't been accounted for
			String minNodeKey = pickMinDistance(found,graph,distances);
			Node minNode = graph.get(minNodeKey);
			//System.out.println(minNode);
			//adds it to the hm of nodes that have been found
			found.put(minNodeKey, minNode);

			//gets neighboring edges of the minNode
			ArrayList<Edge> neighbors = minNode.getNeighbors();

			System.out.println("neighbors "+ neighbors);

			for(int i = 0; i<neighbors.size(); i++)
			{
				int checkingDistance = distances.get(neighbors.get(i).getNeighbor(minNode).getLabel())+neighbors.get(i).getWeight();
				int minNodeDistance = distances.get(minNodeKey);

				System.out.println("check "+checkingDistance);
				System.out.println("min "+minNodeDistance);

				if(checkingDistance == minNodeDistance)
				{
					ArrayList<Edge> newPath = new ArrayList<Edge>();
					newPath.addAll(path.get(neighbors.get(i).getNeighbor(minNode).getLabel()));
					newPath.add(neighbors.get(i));
					path.put(minNodeKey,newPath);
				}
			}

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
			System.out.println(distances);
		}
		return path;
	}

	public static ArrayList<Edge> getShortestPath(String start, String end, HashMap<String,Node> graph)
	{
		ArrayList<Edge> shortestPath = new ArrayList<Edge>();
		HashMap<String,ArrayList<Edge>> paths = getShortestPaths(graph,start);
		return paths.get(end);
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
