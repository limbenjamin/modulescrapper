import urllib2

for line in open('modulecode.txt','r').readlines():
	url= "http://ivle7.nus.edu.sg/lms/Account/NUSBulletin/msearch_view.aspx?modeCode="
	str2= "&acadYear=2013/2014&semester=1"
	line = line.rstrip('\r\n')
	code = line
	url += line
	url += str2
	req = urllib2.Request(url)
	res = urllib2.urlopen(req)
	outfile = file ("%s" % code,'w')
	outfile.write(res.read())
	outfile.close()
	
