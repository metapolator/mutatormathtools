#!/bin/env python

import os
import sys

basePath = os.path.dirname(os.path.realpath(__file__))
modulePath = basePath + "/python_modules/lib/python"
print "modulePath " + modulePath
sys.path.append( modulePath )

import defcon
import mutatorMath
import mutatorMath.ufo.document as udoc
import mutatorMath.objects.location as mmlocation


if __name__ == "__main__":

    if len(sys.argv) < 4:
        print "Usage: simpleblend masterA.ufo masterB.ufo weight 0.5 "
        print "  will create an instance 50% between both masters"
        print "  note that masterA will have weight set to 1.0"
        print "        and masterB will have weight set to 0.0"
        sys.exit(2)

    masterA  = sys.argv[1]
    masterB  = sys.argv[2]
    axisName = sys.argv[3]
    instanceLocation = float(sys.argv[4])

    print "creating an instance on axis " + axisName + " that is " \
        + str(instanceLocation) + " between your masters"
    print " first master: " + masterA
    print "second master: " + masterB

    dw = udoc.DesignSpaceDocumentWriter("simpleblend.designspace")
    d = dict()
    d[axisName] = 1
    dw.addSource( masterA, "masterA", mmlocation.Location(d) )
    d[axisName] = 0
    dw.addSource( masterB, "masterB", mmlocation.Location(d) )

    d[axisName] = instanceLocation
    dw.startInstance( "interpolated", mmlocation.Location(d), 
                      "familyName", "styleName", "out.ufo" )
#    dw.writeGlyph("o");
    dw.endInstance()
    dw.save()

    # make an instance instanceLocation % of the way between the two masters
    dr = udoc.DesignSpaceDocumentReader("simpleblend.designspace", 2)
    dr.process()

    # output the instance as ufo for inspection
    # (done in the above already)
