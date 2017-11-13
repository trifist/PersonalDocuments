import os
import pdb

class Node:
    nextNode = None
    data = []

nodes = []

def expand(node, string):
    for d in node.data:
        if(node.nextNode):
            expand(node.nextNode, string + d)
        else:
            print(string + d + "|\n")

def main():
    rawData = input("Please input data, 'N' for exit:\n")
    while(rawData != "N"):
        node = Node()
        node.data = rawData.split("|")
        nodes.append(node)
        rawData = input()

    for i in range(len(nodes)-1):
        nodes[i].nextNode = nodes[i+1]

    expand(nodes[0], "")
    return 0

if(__name__=="__main__"):
    main()
