use Test2::V0 -no_srand => 1;
use WebService::Dist;

subtest 'foreign_package_name' => sub {

  is(foreign_package_name('deb', 'FFI::Platypus'), 'libffi-platypus-perl');
  is(foreign_package_name('deb', 'FFI-Platypus'), 'libffi-platypus-perl');
  is( dies { foreign_package_name('foo', 'FFI::Platypus') }, match qr/^unknown vendor: foo/);

  is(foreign_package_name('rpm', 'FFI::Platypus'), 'perl-FFI-Platypus');
  is(foreign_package_name('rpm', 'FFI-Platypus'), 'perl-FFI-Platypus');

  is(foreign_package_name('freebsd', 'FFI::Platypus'), 'p5-FFI-Platypus');
  is(foreign_package_name('freebsd', 'FFI-Platypus'), 'p5-FFI-Platypus');

  is(foreign_package_name('openbsd', 'FFI::Platypus'), 'p5-FFI-Platypus');
  is(foreign_package_name('openbsd', 'FFI-Platypus'), 'p5-FFI-Platypus');
};

subtest 'foreign_package_exists' => sub {

  foreach my $vendor (qw( deb rpm freebsd ))
  {
    subtest $vendor => sub {
      is(foreign_package_exists($vendor, 'FFI::Platypus'), T());
      is(foreign_package_exists($vendor, 'FFI-Platypus'), T());
      is(foreign_package_exists($vendor, 'Totally-Bogus'), F());
    };
  }

  foreach my $vendor (qw( openbsd ))
  {
    subtest 'openbsd' => sub {
      is(foreign_package_exists($vendor, 'Module-Build'), T());
      is(foreign_package_exists($vendor, 'Module-Build'), T());
      is(foreign_package_exists($vendor, 'Totally-Bogus'), F());
    };
  }

  is( dies { foreign_package_exists('foo', 'FFI::Platypus') }, match qr/^unknown vendor: foo/);

};

done_testing;
