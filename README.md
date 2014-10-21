
There is probably a better way of doing this, but I decided to install
all the needed python dependencies into python_modules, ala npm for
python. This should also work if you have installed the needed modules
system or user wide, though you might like to mkdir python_modules so
the path still exists.

I had to change the code to some of the dependencies, so it is useful
to have them installed into a subdirectory of the mutatormathtools
checkout. In particular some of the code that MutatorMath uses tries
to do the right thing by prepending the local path to the path to a
file to open, sometimes this results in disaster with
/path/to/mutatormathtools/fonts/Merriweather-Regular.ufo being doubled
up at the start of a path to reference a file like metainfo.plist.
Worse still the code actually hides those errors, raising coarser
errors without a hint that the issue stemmed from a file path issue
rather than something deeper. When you see a complaint on the command
line about metainfo.plist being invalid it might just be that the path
eventually used to read that file is invalid rather than the file
itself.

The first example takes the Merriweather font using Bold as a weight
of 1.0 and Regular as a weight of 0.0 and allows you to export an
instance that is somewhere in between those two extremes. To do this
in the most simple of ways just execute the following command which
will generate out.ufo in the current directory for an instance 50% the
way between the normal and bold masters.

./run-merriweather.sh

In the above run script you will see that the 3rd parameter to
./simpleblend.py is weight which is the axis we are hoping to change.
The fourth parameter is 0.5 which is where in the range of 0 (normal)
to 1 (bold) you would like the instance to be.

Note that the script also shows you the project designspace XML file
to compare with that on the MutatorMath site:
https://github.com/LettError/MutatorMath

A final touchup to out.ufo/fontinfo.plist allows FontForge (and other
applications) to make sense of the out.ufo instance font file.

I hope that this example is doing things correctly. It was created
independent of the MutatorMath project from RTFM & RTFS. (Constructive)
Comments, especially constructive criticism, feedback, and good pull
requests very welcome!

---

Use the metapolator-interpolate.js command to run metapolator and
generate output. The script requires two font names and an output, and
by default generates an instance 50% between the two masters. You can
select masters just by name if they are in the ./fonts top level
directory of mutatormathtools. So the following command should be
valid:

$ ./metapolator-interpolate.js       \
    -a Khula-Light-090x-456.ufo      \
    -b Khula-ExtraBold-090x-456.ufo  \
    -o /tmp/foo.ufo

A master script ./update-example-output.sh will update all the example
output that is contained in your example-output subdirectory. Note
that the example-output directory is itself under git control, so you
probably want to make a throw away branch before running
update-example-output.sh.


