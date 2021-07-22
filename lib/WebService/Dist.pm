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

=head1 FUNCTIONS

=head2 foreign_package_name

 my $name = foreign_package_name $vendor, $name;

Given a valid vendor (C<deb>) and a dist or module name (example: L<FFI::Platypus> or C<FFI-Platypus>), return
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
  else
  {
    die "unknown vendor: $vendor";
  }

  my $res = $ua->head($url);
  return $res->is_success;
}

1;
