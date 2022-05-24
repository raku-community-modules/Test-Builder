#= Handles output operations for Test::Builder objects
class Test::Builder::Output {
    has $!stdout = $*OUT;    #= Filehandle used by write()
    has $!stderr = $*ERR;    #= Filehandle used by diag()

    #= Displays output to filehandle set by $.stdout
    method write(Str $msg is copy --> Nil) {
        #$msg ~~ s:g/\n <!before \#>/\n \# <space>/;
        $!stdout.say($msg);
    }

    #= Displays diagnostic message to filehandle set by $.stderr
    method diag(Str $msg is copy --> Nil) {
        # XXX Uncomment lines when Rakudo supports negative lookahead assertions
        #$msg ~~ s/^ <!before \#>/\# <space>/;
        #$msg ~~ s:g/\n <!before \#>/\n \# <space>/;

        $msg ~~ s/^/\x23 \x20/;
        $msg.=subst("\x0a", "\x0a\x23\x20");

        $!stderr.say($msg)
    }
}

=begin pod

=head1 NAME

Test::Builder::Output - handles output operations for Test::Builder objects

=head1 DESCRIPTION

The purpose of the C<Test::Builder::Output> class is to manage all output
operations for C<Test::Builder> objects. It is generally used for reporting
test results and displaying diagnostics for test failures.

B<NOTE:> The C<Test::Builder::Output> class should not be used directly.
It is only meant to be used internally.

=head1 USE

=head2 Public Attributes

=head3 I<$.stdout>

Specifies the filehandle that should be used for normal output such as
reporting individual test results and the final pass/fail status.

Defaults to C<$*OUT>.

=head3 I<$.stderr>

Specifies the filehandle that should be used for diagnostic messages such as
test failures and other fatal errors.

Defaults to C<$*ERR>.

=head2 Object Initialization

=head3 B<new()>

Returns a new C<Test::Builder::Output> instance.

=head2 Public Methods

=head3 B<write(Str $msg)>

Writes the string given in C<$msg> to the filehandle specified by C<$.stdout>.

The C<write()> method is generally used for normal output such as reporting
test results.

=head3 B<diag(Str $msg)>

Writes the string given in C<$msg> to the filehandle specified by C<$.stderr>.

The diagnostic messages displayed by C<diag()> are distinct from other output
in that they are always prefixed with an octothorpe (C<#>).

=end pod

# vim: expandtab shiftwidth=4
