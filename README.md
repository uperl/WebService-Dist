# WebService::Dist ![static](https://github.com/uperl/WebService-Dist/workflows/static/badge.svg) ![linux](https://github.com/uperl/WebService-Dist/workflows/linux/badge.svg)

Find if there is a dist for that Perl module

# SYNOPSIS

```perl
use WebService::Dist;

if(foreign_package_exists 'deb', 'FFI-Platypus')
{
  print "there is a debian package for FFI-Platypus';
}
```

# DESCRIPTION

This modules just provides some functions for determining if a vendor provides a particular CPAN dist as a package.

# FUNCTIONS

## foreign\_package\_name

```perl
my $name = foreign_package_name $vendor, $name;
```

Given a valid vendor (`deb`, `rpm`, `freebsd` or `openbsd`) and a dist or module name (example: [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) or `FFI-Platypus`), return
the normal package name for that vendor (example: `libffi-platypus-perl`).

## foreign\_package\_exists

```perl
my $bool = foreign_package_exists $vendor, $name;
```

Given a vendor and a dist or module name, return true if the vendor provides that package.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
