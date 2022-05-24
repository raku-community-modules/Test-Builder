role Test::Builder::Test::Generic {
    has        $.passed;
    has Int:D  $.number      = 0;
    has Str:D  $.diagnostic  = '???';
    has Str:D  $.description = '';

    method status(--> Hash:D) {
        { :$.passed, :$.description }
    }

    method report(--> Str:D) {
        my $result = $.passed ?? 'ok ' !! 'not ok ';

        $result   ~= $.number;
        $result   ~= " - $.description" if $.description;

        $result
    }

    method verbose_report(%verbose --> Str:D) {
        "    got: %verbose<got>\nexpected: %verbose<expected>"
    }
}

role Test::Builder::Test::Reason does Test::Builder::Test::Generic {
    has Str:D $.reason = '';

    # XXX Consider making status() generic, i.e. has no definition
    method status(--> Hash:D) {
        my %status      = callsame;
        %status<reason> = $.reason;

        %status
    }
}

class Test::Builder::Test::Pass does Test::Builder::Test::Generic { }
class Test::Builder::Test::Fail does Test::Builder::Test::Generic { }

class Test::Builder::Test::Todo does Test::Builder::Test::Reason {
    method report(--> Str:D) {
        ($.passed ?? 'ok' !! 'not ok') ~ " $.number # TODO $.description"
    }

    method status(--> Hash:D) {
        my %status = callsame;

        %status<todo>          = True;
        %status<passed>        = True;
        %status<really_passed> = $.passed;

        %status
    }
}

class Test::Builder::Test::Skip does Test::Builder::Test::Reason {
    method report(--> Str:D) {
        "not ok $.number \#skip $.reason";
    }

    method status(--> Hash:D) {
        my %status    = callsame;
        %status<skip> = True;

        %status
    }
}

class Test::Builder::Test {
    method new(
      Int:D  :$number is required,
      Bool:D :$passed      = True,
      Bool:D :$skip        = False,
      Bool:D :$todo        = False,
      Str:D  :$reason      = '',
      Str:D  :$description = '') {

        $todo
          ?? Todo.new(:$description, :$passed, :$reason, :$number)
          !! $skip
            ?? Skip.new(:$description, :passed, :$reason, :$number)
            !! $passed
              ?? Pass.new(:$description, :passed, :$number)
              !! Fail.new(:$description, :!passed, :$number)
    }
}

# vim: expandtab shiftwidth=4
