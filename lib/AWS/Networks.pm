package AWS::Networks;
  use Moose;
  use JSON;
  use HTTP::Tiny;
  use DateTime;

  has url => (
    is => 'ro', 
    isa => 'Str', 
    default => 'https://ip-ranges.amazonaws.com/ip-ranges.json'
  );

  has netinfo => (
    is => 'ro',
    isa => 'HashRef',
    default => sub {
      my $self = shift;
      die "Can't get some properties from derived results" if (not $self->url);
      my $response = HTTP::Tiny->new->get($self->url);
      die "Error downloading URL" unless ($response->{ success });
      return decode_json($response->{ content });
    },
    lazy => 1,
  );

  has sync_token => (
    is => 'ro',
    isa => 'Int',
    default => sub {
      return DateTime->from_epoch( shift->netinfo->{ syncToken } );
    },
    lazy => 1,
  );

  has networks => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub {
      return shift->netinfo->{ prefixes };
    },
    lazy => 1,
  );

  has regions => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub {
      my ($self) = @_;
      my $regions = {};
      map { $regions->{ $_->{ region } } = 1 } @{ $self->networks };
      return [ keys %$regions ];
    },
    lazy => 1,
  );

  sub by_region {
    my ($self, $region) = @_;
    return AWS::Networks->new(
      url => '',
      networks => [ grep { $_->{ region } eq $region } @{ $self->networks }  ]
    );
  }

  has services => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub {
      my ($self) = @_;
      my $services = {};
      map { $services->{ $_->{ service } } = 1 } @{ $self->networks };
      return [ keys %$services ];
    },
    lazy => 1,
  );

  sub by_service {
    my ($self, $service) = @_;
    return AWS::Networks->new(
      url => '',
      networks => [ grep { $_->{ service } eq $service } @{ $self->networks }  ]
    );
  }

  has cidrs => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub {
      my ($self) = @_;
      return [ map { $_->{ ip_prefix } } @{ $self->networks } ];
    },
    lazy => 1,
  );

1;
