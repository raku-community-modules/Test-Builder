[![Actions Status](https://github.com/raku-community-modules/Test-Builder/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/Test-Builder/actions)

class Test::Builder
-------------------

Global Test::Builder singleton object

### has Positional @!results

Stack containing results of each test

### has Test::Builder::Plan::Generic $!plan

Sets up number of tests to run

class Attribute+{<anon|2>}.new(handles => "diag")
-------------------------------------------------

Handles all output operations

### has Bool $.done_testing

Specifies whether or not .done() has been called

### method new

```raku
method new() returns Mu
```

Returns the Test::Builder singleton object

### method create

```raku
method create() returns Mu
```

Returns a new Test::Builder instance

### method done

```raku
method done() returns Nil
```

Declares that no more tests need to be run

### multi method plan

```raku
multi method plan(
    Int:D $tests
) returns Nil
```

Declares the number of tests to run

### multi method plan

```raku
multi method plan(
    Whatever $
) returns Nil
```

Declares that the number of tests is unknown

### multi method plan

```raku
multi method plan(
    $any
) returns Nil
```

Default candidate for arguments of the wrong type

### method ok

```raku
method ok(
    Mu $test,
    Str:D $description = ""
) returns Mu
```

Tests the first argument for boolean truth

### method nok

```raku
method nok(
    Mu $test,
    Str:D $description = ""
) returns Mu
```

Tests the first argument for boolean false

### method is

```raku
method is(
    Mu $got,
    Mu $expected,
    Str:D $description = ""
) returns Mu
```

Verifies that the first two arguments are equal

### method isnt

```raku
method isnt(
    Mu $got,
    Mu $expected,
    Str:D $description = ""
) returns Mu
```

Verifies that the first two arguments are not equal

### method todo

```raku
method todo(
    Mu $todo,
    Str:D $description = "",
    Str:D $reason = ""
) returns Mu
```

Marks a given number of tests as failures

### method report_test

```raku
method report_test(
    Test::Builder::Test::Generic:D $test,
    :%verbose
) returns Nil
```

Displays the results of the given test

### method get_test_number

```raku
method get_test_number() returns Mu
```

Returns the current test number

NAME
====

Test::Builder - flexible framework for building TAP test libraries

SYNOPSIS
========

```raku
my $tb = Test::Builder.new;

$tb.plan(2);

$tb.ok(1, 'This is a test');
$tb.ok(1, 'This is another test');

$tb.done;
```

DESCRIPTION
===========

`Test::Builder` is meant to serve as a generic backend for test libraries. Put differently, it provides the basic "building blocks" and generic functionality needed for building your own application-specific TAP test libraries.

`Test::Builder` conforms to the Test Anything Protocol (TAP) specification.

USE
===

Object Initialization
---------------------

### **new()**

Returns the `Test::Builder` singleton object.

The `new()` method only returns a new object the first time that it's called. If called again, it simply returns the same object. This allows multiple modules to share the global information about the TAP harness's state.

Alternatively, if a singleton object is too limiting, you can use the `create()` method instead.

### **create()**

Returns a new `Test::Builder` instance.

The `create()` method should only be used under certain circumstances. For instance, when testing `Test::Builder`-based modules. In all other cases, it is recommended that you stick to using `new()` instead.

Implementing Tests
------------------

The following methods are responsible for performing the actual tests.

All methods take an optional string argument describing the nature of the test.

### **plan(Int $tests)**

Declares how many tests are going to be run.

If called as `.plan(*)`, then a plan will not be set. However, it is your job to call `done()` when all tests have been run.

### **ok(Mu $test, Str $description)**

Evaluates `$test` in a boolean context. The test will pass if the expression evaluates to `Bool::True` and fail otherwise.

### **nok(Mu $test, Str $description)**

The antithesis of `ok()`. Evaluates `$test` in a boolean context. The test will pass if the expression evaluates to `Bool::False` and fail otherwise.

Modifying Test Behavior
-----------------------

### **todo(Str $reason, Int $count)**

Marks the next `$count` tests as failures but ignores the fact. Test execution will continue after displaying the message in `$reason`.

It's important to note that even though the tests are marked as failures, they will still be evaluated. If a test marked with `todo()` in fact passes, a warning message will be displayed.

# TODO The todo() method doesn't actually does this yet but I want it to

SEE ALSO
========

[http://testanything.org](http://testanything.org)

AUTHOR
======

Kevin Polulak

ACKNOWLEDGEMENTS
================

`Test::Builder` was largely inspired by chromatic's work on the old `Test::Builder` module for Pugs.

Additionally, `Test::Builder` is based on the Perl module of the same name also written by chromatic and Michael G. Schwern.

COPYRIGHT
=========

Copyright 2011 Kevin Polulak

Copyright 2012 - 2022 Raku Community

This program is distributed under the terms of the Artistic License 2.0.

