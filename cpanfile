requires 'JSON::MaybeXS';
requires 'HTTP::Tiny';
requires 'Moose';
requires 'DateTime';
requires 'IO::Socket::SSL';
requires 'File::Slurp';
requires 'Net::CIDR::Set';

on test => sub {
  requires 'Test::More';
  requires 'Test::Exception';
  requires 'Test::Pod';
  requires 'Test::Pod::Coverage';
};

