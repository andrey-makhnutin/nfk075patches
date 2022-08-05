# nfk075patches

This is x86 assembly patches made by Boobl (Andrey Makhnutin) for Need For Kill 0.75
Original source codes of NFK 0.75 were lost.

This repository is fork of https://bitbucket.org/pqr/nfk075patches

Game preview: http://www.youtube.com/watch?v=FgvgVttl0zE
More about Need For Kill: http://info.needforkill.ru

# History

Originally these patches were made to detect and then fix memory leaks within the game,
so that it could be possible to host a long running server.

Later patches were added to fix other gameplay, networking and graphic bugs, and creating
new small game features.

# How it works

The assembly code is first assembled into a temporary "executable" file.
Then the patching program is run, which copies parts of binary data from temporary file
directly on top of an original game executable. The original game executable also has
an empty executable section at the end of a file, which was added manually.
