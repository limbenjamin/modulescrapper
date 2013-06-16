import urllib2

for line in open('empty','r').readlines():
	line = line.rstrip('\r\n')
	outfile = file ("%s" % line,'w')
	outfile.write("\n")
	outfile.close()
	
