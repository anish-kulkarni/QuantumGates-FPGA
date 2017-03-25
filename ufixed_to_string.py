print "conv : process(temp) \nbegin";
N = 100;
for n in range(256):
    a = '{0:08b}'.format(n);
    print "\telsif temp = \"%s\" then" % a;
    number = 0.0
    for m in range(8):
        number = number +  float(a[m])*(2**(3-m));
    print "\t \tresult <= \"%s\";" % '{0:07.4f}'.format(number);
    #print number
print "\tend if;"
print "end process conv;"