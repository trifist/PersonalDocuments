import os
import pdb

class Node:
    nextNode = None
    data = []

nodes = []

def expand(node, string, fo):
    for d in node.data:
        if(node.nextNode):
            expand(node.nextNode, string + d, fo)
        else:
            fo.write(string + d + "|\n")
            print(string + d + "|")

def main():
    rawData = input("Please input data, press 'N' to exit:\n")
    while(rawData != "N"):
        node = Node()
        node.data = rawData.split("|")
        nodes.append(node)
        rawData = input()

    for i in range(len(nodes)-1):
        nodes[i].nextNode = nodes[i+1]

    fo = open("./result.txt", "w", encoding="gbk")
    expand(nodes[0], "", fo)
    fo.close()
    input("Press Enter to exit")
    return 0

if(__name__=="__main__"):
    main()
