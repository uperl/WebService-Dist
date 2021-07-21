use Test2::V0 -no_srand => 1;
use WebService::Dist;

subtest 'foreign_package_name' => sub {

  is(foreign_package_name('deb', 'FFI::Platypus'), 'libffi-platypus-perl');
  is(foreign_package_name('deb', 'FFI-Platypus'), 'libffi-platypus-perl');
  is( dies { foreign_package_name('foo', 'FFI::Platypus') }, match qr/^unknown vendor: foo/);

};

subtest 'foreign_package_exists' => sub {

  is(foreign_package_exists('deb', 'FFI::Platypus'), T());
  is(foreign_package_exists('deb', 'FFI-Platypus'), T());
  is(foreign_package_exists('deb', 'Totally-Bogus'), F());
  is( dies { foreign_package_exists('foo', 'FFI::Platypus') }, match qr/^unknown vendor: foo/);

};

done_testing;
