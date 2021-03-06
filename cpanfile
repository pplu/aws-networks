requires 'JSON::MaybeXS';
requires 'HTTP::Tiny';
requires 'Moose';
requires 'DateTime';
requires 'IO::Socket::SSL';

on test => sub {
  requires 'File::Slurp';
  requires 'Test::More';
  requires 'Test::Exception';
  requires 'Test::Pod';
  requires 'Test::Pod::Coverage';
};

