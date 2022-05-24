# TODO Define Test::Builder::Exception
# TODO Replace die() with fail()

use Test::Builder::Test;
use Test::Builder::Plan;
use Test::Builder::Output;

class Test::Builder { ... };

#= Global Test::Builder singleton object
my Test::Builder $TEST_BUILDER;

class Test::Builder {
    #= Stack containing results of each test
    has                              @!results;

    #= Sets up number of tests to run
    has Test::Builder::Plan::Generic $!plan;

    #= Handles all output operations
    has Test::Builder::Output        $!output handles 'diag';

    #= Specifies whether or not .done() has been called
    has Bool                         $.done_testing is rw;

    #= Returns the Test::Builder singleton object
    method new() { $TEST_BUILDER //= self.create }

    #= Returns a new Test::Builder instance
    method create() { $?CLASS.bless }

    submethod BUILD(
      Test::Builder::Plan   $!plan?,
      Test::Builder::Output $!output = Test::Builder::Output.new
    ) { }

    #= Declares that no more tests need to be run
    method done(--> Nil) {
        $.done_testing = True;

        # "Cannot look up attributes in a type object" error check.
        my $footer = $!plan.footer(+@!results) if ?$!plan;
        $!output.write($footer) if $footer;
    }

    #= Declares the number of tests to run
    multi method plan(Int:D $tests --> Nil) {
        die 'Plan already set!' if $!plan;

        $!plan = Test::Builder::Plan.new(:expected($tests));
    }

    #= Declares that the number of tests is unknown
    multi method plan(Whatever --> Nil) {
        die 'Plan already set!' if $!plan;

        $!plan = Test::Builder::NoPlan.new;
    }

    # TODO Implement skip_all and no_plan
    multi method plan(Str:D $explanation --> Nil) { ... }

    #= Default candidate for arguments of the wrong type
    multi method plan($any --> Nil) {
        die 'Unknown plan!';
    }

    #= Tests the first argument for boolean truth
    method ok(Mu $test, Str:D $description = '') {
        self!report_test(
          Test::Builder::Test.new(
            :number(self!get_test_number),
            :passed(?$test),
            :description($description)
          )
        );

        $test
    }

    #= Tests the first argument for boolean false
    method nok(Mu $test, Str:D $description = '') {
        self!report_test(
          Test::Builder::Test.new(
            :number(self!get_test_number),
            :passed(!$test),
            :description($description)
          )
        );

        $test
    }

    #= Verifies that the first two arguments are equal
    method is(Mu $got, Mu $expected, Str:D $description = '') {
        my Bool $test = $got eq $expected;

        # Display verbose report unless test passed
        if $test {
            self!report_test(
              Test::Builder::Test.new(
                :number(self!get_test_number),
                :passed($test),
                :description($description)
              )
            );
        }
        else {
            self!report_test(
              Test::Builder::Test.new(
                :number(self!get_test_number),
                :passed($test),
                :description($description)
              ),
              :verbose({ got => $got, expected => $expected })
            );
        }

        $test
    }

    #= Verifies that the first two arguments are not equal
    method isnt(Mu $got, Mu $expected, Str:D $description = '') {
        my Bool $test = $got ne $expected;

        # Display verbose report unless test passed
        if $test {
            self!report_test(
              Test::Builder::Test.new(
                :number(self!get_test_number),
                :passed($test),
                :description($description)
              )
            );
        }
        else {
            self!report_test(
              Test::Builder::Test.new(
                :number(self!get_test_number),
                :passed($test),
                :description($description)
              ),
              :verbose({ got => $got, expected => $expected })
            );
        }

        $test
    }

    #= Marks a given number of tests as failures
    method todo(Mu $todo, Str:D $description = '', Str:D $reason = '') {
        self!report_test(
          Test::Builder::Test.new(
            :todo,
            :number(self!get_test_number),
            :reason($reason),
            :description($description)
          )
        );

        $todo
    }

    #= Displays the results of the given test
    method !report_test(
      Test::Builder::Test::Generic:D $test,
      :%verbose
    --> Nil) {
        die 'No plan set!' unless $!plan;

        @!results.push($test);

        $!output.write($test.report);
        $!output.diag($test.verbose_report(%verbose)) if %verbose;
    }

    #= Returns the current test number
    method !get_test_number() { @!results + 1 }
}

END {
    $TEST_BUILDER.done
      if $TEST_BUILDER.defined && !$TEST_BUILDER.done_testing
}

=begin pod

=head1 NAME

Test::Builder - flexible framework for building TAP test libraries

=head1 SYNOPSIS

=begin code :lang<raku>

my $tb = Test::Builder.new;

$tb.plan(2);

$tb.ok(1, 'This is a test');
$tb.ok(1, 'This is another test');

$tb.done;

=end code

=head1 DESCRIPTION

C<Test::Builder> is meant to serve as a generic backend for test libraries. Put
differently, it provides the basic "building blocks" and generic functionality
needed for building your own application-specific TAP test libraries.

C<Test::Builder> conforms to the Test Anything Protocol (TAP) specification.

=head1 USE

=head2 Object Initialization

=head3 B<new()>

Returns the C<Test::Builder> singleton object.

The C<new()> method only returns a new object the first time that it's called.
If called again, it simply returns the same object. This allows multiple
modules to share the global information about the TAP harness's state.

Alternatively, if a singleton object is too limiting, you can use the
C<create()> method instead.

=head3 B<create()>

Returns a new C<Test::Builder> instance.

The C<create()> method should only be used under certain circumstances. For
instance, when testing C<Test::Builder>-based modules. In all other cases, it
is recommended that you stick to using C<new()> instead.

=head2 Implementing Tests

The following methods are responsible for performing the actual tests.

All methods take an optional string argument describing the nature of the test.

=head3 B<plan(Int $tests)>

Declares how many tests are going to be run.

If called as C<.plan(*)>, then a plan will not be set. However, it is your job
to call C<done()> when all tests have been run.

=head3 B<ok(Mu $test, Str $description)>

Evaluates C<$test> in a boolean context. The test will pass if the expression
evaluates to C<Bool::True> and fail otherwise.

=head3 B<nok(Mu $test, Str $description)>

The antithesis of C<ok()>. Evaluates C<$test> in a boolean context. The test
will pass if the expression evaluates to C<Bool::False> and fail otherwise.

=head2 Modifying Test Behavior

=head3 B<todo(Str $reason, Int $count)>

Marks the next C<$count> tests as failures but ignores the fact. Test
execution will continue after displaying the message in C<$reason>.

It's important to note that even though the tests are marked as failures, they
will still be evaluated. If a test marked with C<todo()> in fact passes, a
warning message will be displayed.

# TODO The todo() method doesn't actually does this yet but I want it to

=head1 SEE ALSO

L<http://testanything.org>

=head1 AUTHOR

Kevin Polulak

=head1 ACKNOWLEDGEMENTS

C<Test::Builder> was largely inspired by chromatic's work on the old
C<Test::Builder> module for Pugs.

Additionally, C<Test::Builder> is based on the Perl module of the same name
also written by chromatic and Michael G. Schwern.

=head1 COPYRIGHT

Copyright 2011  Kevin Polulak

Copyright 2012 - 2022 Raku Community

This program is distributed under the terms of the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
