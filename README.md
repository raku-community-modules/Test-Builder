# Test::Builder

This is a flexible framework for building TAP test libraries.

It provides the basic "building blocks" and generic functionality needed for building your own
application-specific TAP test libraries.


## Source Code

The source code for Test::Builder is available at <https://github.com/perl6-community-modules/p6-test-builder>.

To obtain a local copy of the source code, run:

    git clone git@github.com:perl6-community-modules/p6-test-builder.git p6-test-builder


## Installation

Once you've obtained a copy of the source code, run:

    ufo             # Creates Makefile
    make            # Builds module
    make test       # Runs test suite
    make install    # Installs to ~/.perl6/lib

If you wish to remove the files generated during the build/install process, run:

    make clean        # Removes generated files
    make distclean    # 'make clean' and removes Makefile


## Feedback

If you experience a bug, error, or just want to make a suggestion, you can
open a [GitHub issue](https://github.com/perl6-community-modules/p6-test-builder/issues)
or discuss the issue with the nice people on the #perl6 channel on irc.freenode.net.

If you know how to fix the problem you encountered, forking a clone on
GitHub and submitting a Pull Request.


## Author

Originally written by Kevin Polulak:
    Email: kpolulak@gmail.com
    IRC:   soh_cah_toa

Now maintained by The Perl6 Community:
    GitHub: https://github.com/perl6-community-modules


## Copyright and License

Copyright (C) 2011, Kevin Polulak <kpolulak@gmail.com>.
Copyright (C) 2015-2016 The Perl6 Community.

This program is distributed under the terms of the Artistic License 2.0.

For further information, please see the LICENSE or visit
<http://www.perlfoundation.org/attachment/legal/artistic-2_0.txt>.
