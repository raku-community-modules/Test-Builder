# Copyright (C) 2011, Kevin Polulak <kpolulak@gmail.com>.

# TODO  Rename Test::Builder::Base to something else
# FIXME Refactor Test::Builder::Base inheritance tree

role Test::Builder::Test::Base {
    has      $.passed;
    has Int  $.number     = 0;
    has Str  $.diagnostic = '???';
    has Str  $.description;

    method status() returns Hash {
        return {
            passed      => $.passed,
            description => $.description
        };
    }

    method report() returns Str {
        my $result = $.passed ?? 'ok ' !! 'not ok ';

        $result   ~= $.number;
        $result   ~= " - $.description" if $.description;

        return $result;
    }
}

role Test::Builder::Test::Reason does Test::Builder::Test::Base {
    has Str $.reason;

    #submethod BUILD($.reason) { }

    # XXX Consider making status() generic, i.e. has no definition
    method status() returns Hash {
        my %status      = self.SUPER::status;
        %status<reason> = $.reason;

        return %status;
    }
}

class Test::Builder::Test::Pass does Test::Builder::Test::Base { }
class Test::Builder::Test::Fail does Test::Builder::Test::Base { }

class Test::Builder::Test::Todo does Test::Builder::Test::Reason {
    method report() returns Str {
        my $result = $.passed ?? 'ok' !! 'not ok';
        return join ' ', $result, $.number, "# TODO $.description";
    }

    method status() returns Hash {
        my %status = self.SUPER::status;

        %status<todo>          = 1;
        %status<passed>        = Bool::True;
        %status<really_passed> = $.passed;

        return %status;
    }
}

class Test::Builder::Test::Skip does Test::Builder::Test::Reason {
    method report() returns Str {
        return "not ok $.number \#skip $.reason";
    }

    method status() returns Hash {
        my %status    = self.SUPER::status;
        %status<skip> = 1;

        return %status;
    }
}

class Test::Builder::Test {
    has $!passed;
    has $!number;
    has $!diag;
    has $!description;

    # XXX Should $passed be of type Bool instead?

    method new(Int :$number,
               Int :$passed      = 1,
               Int :$skip        = 0,
               Int :$todo        = 0,
               Str :$reason      = '',
               Str :$description = '') {

        return Test::Builder::Test::Todo.new(:description($description),
                                             :passed($passed),
                                             :reason($reason),
                                             :number($number)) if $todo;

        return Test::Builder::Test::Skip.new(:description($description),
                                             :passed(1),
                                             :reason($reason),
                                             :number($number)) if $skip;

        return Test::Builder::Test::Pass.new(:description($description),
                                             :passed(1),
                                             :number($number)) if $passed;

        return Test::Builder::Test::Fail.new(:description($description),
                                             :passed(0),
                                             :number($number));
    }

    method report() returns Str {
        my $result = $!passed ?? 'ok ' !! 'not ok ';

        $result   ~= $!number;
        $result   ~= " - $!description" if $!description;

        return $result;
    }
}

# vim: ft=perl6

