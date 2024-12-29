package WebService::Dist;

use strict;
use warnings;
use 5.020;
use experimental qw( signatures );
use LWP::UserAgent;
use Exporter qw( import );

our @EXPORT = qw( foreign_package_name foreign_package_exists );

# ABSTRACT: Find if there is a dist for that Perl module
# VERSION

=head1 SYNOPSIS

 use WebService::Dist;

 if(foreign_package_exists 'deb', 'FFI-Platypus')
 {
   print "there is a debian package for FFI-Platypus';
 }

=head1 DESCRIPTION

This modules just provides some functions for determining if a vendor provides a particular CPAN dist as a package.

=head1 FUNCTIONS

=head2 foreign_package_name

 my $name = foreign_package_name $vendor, $name;

Given a valid vendor (C<deb>, C<rpm>, C<freebsd> or C<openbsd>) and a dist or module name (example: L<FFI::Platypus> or C<FFI-Platypus>), return
the normal package name for that vendor (example: C<libffi-platypus-perl>).

=cut

sub foreign_package_name ($vendor,$name)
{
  $name =~ s/::/-/g; # in case we are given a module instead of a dist

  if($vendor eq 'deb')
  {
    my $deb = lc $name;
    return "lib$deb-perl";
  }
  elsif($vendor eq 'rpm')
  {
    return "perl-$name";
  }
  elsif($vendor =~ /^(free|open)bsd$/)
  {
    return "p5-$name";
  }
  else
  {
    die "unknown vendor: $vendor";
  }
}

=head2 foreign_package_exists

 my $bool = foreign_package_exists $vendor, $name;

Given a vendor and a dist or module name, return true if the vendor provides that package.

=cut

sub foreign_package_exists ($vendor, $name)
{
  my $package_name = foreign_package_name($vendor, $name);

  my $url;
  my $ua = LWP::UserAgent->new;

  if($vendor eq 'deb')
  {
    $url = "https://packages.debian.org/testing/$package_name";
    my $res = $ua->get($url);
    die $res->status_line unless $res->is_success;
    return !scalar $res->decoded_content =~ /No such package/
  }
  elsif($vendor eq 'rpm')
  {
    $url = "https://src.fedoraproject.org/rpms/$package_name"
  }
  elsif($vendor eq 'freebsd')
  {
    $url = "https://cgit.freebsd.org/ports/tree/devel/$package_name";
  }
  elsif($vendor eq 'openbsd')
  {
    $url = "https://openports.pl/path/devel/$package_name";
    my $res = $ua->get($url);
    # lol this server returns a 404 as a 200
    return '' if $res->code == 200 && $res->decoded_content =~ /Error 404|Not Found/;
    die $res->status_line unless $res->is_success;
    return !scalar $res->decoded_content =~ /The package you requested does not exist/
  }
  else
  {
    die "unknown vendor: $vendor";
  }

  my $res = $ua->head($url);
  return !!$res->is_success;
}

1;
