# coding: utf-8 
# created by wpcheng
# Jan.  26th, 2018
import os
import pdb
import re


class LogAnalyzer(object):
	path = "./"
	keywords = ["SpeechClientService:", "FloatViewService:", "CuteFlyApp:", "SrAdaptListener:", "IvwPcmRecordListener:", "BusinessProcessor:"]
	ignores = ["logcat_kernel.log", "target_log.txt", "compare.txt"]
	pids = set()
	targets = []
	comparePath = "./compare"
	targetPath = "./target_log"

	def __init__(self):
		self.ignores.append(os.path.basename(__file__))
		return
	
	def findTargets(self):
		for root, dirs, fs in os.walk(self.path):
			if(root == "./"):
				for file in fs:
					if(not file in self.ignores):
						self.targets.append(file)
		return
		
	def findPids(self):
		for file in self.targets:
			print("reading file: ", file)
			f = open(file, "rb")
			line = "1"
			lineIndex = 1;
			try:
				while(line):
					line = f.readline().decode("utf8", "replace")
					cols = re.split("\s+", line.strip())
					if(len(cols) < 6):
						lineIndex += 1
						continue
					if(cols[5] in self.keywords):
						self.pids.add(cols[2])
					lineIndex += 1
			except UnicodeDecodeError as error:
				print(error)
				print("error file: ", file, ", error line: ", lineIndex)
			f.close()
		return
		
	def writeLog(self):
		if not os.path.exists(self.targetPath):
			os.mkdir(self.targetPath)
	
		for file in self.targets:
			print("writing file: ", self.targetPath, "/", file, "_target.txt")
			fout = open(self.targetPath + "/" + file + "_target.txt", "w", encoding="utf8")
			f = open(file, "rb")
			line = "1"
			while(line):
				line = f.readline().decode("utf8", "replace")
				cols = re.split("\s+", line.strip())
				if(len(cols) < 6):
					continue
				if(cols[2] in self.pids):
					fout.write(line);
			f.close()
			fout.close()
		return
		
	def writeCompare(self):
		if not os.path.exists(self.comparePath):
			os.mkdir(self.comparePath)
		for file in self.targets:
			fout = open(self.comparePath + "/" + file + "_compare.txt", "w", encoding="utf8")
			fin = open(file, "rb")
			line = "1"
			while(line):
				try:
					line = fin.readline().decode("utf8", "replace")
					fout.write(line)
				except UnicodeDecodeError as error:
					print(error)
			fin.close()
			fout.close()
			
def main():
	analyzer = LogAnalyzer()
	analyzer.findTargets()
	analyzer.findPids()
	analyzer.writeLog()
	#analyzer.writeCompare()
	input("Succeess! Press Enter to exit")
	return 0
	
if(__name__ == "__main__"):
    main()