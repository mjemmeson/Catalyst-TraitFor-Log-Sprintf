package Catalyst::TraitFor::Log::Sprintf;

use 5.008001;

use Moose::Role;
use Data::Dumper ();

{
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Maxdepth = $Data::Dumper::Maxdepth || 4;
    local $Data::Dumper::Terse    = 0;

    my $meta = Class::MOP::get_metaclass_by_name(__PACKAGE__);

    while ( my ( $name, $level ) = each %Catalyst::Log::LEVELS ) {

        $meta->add_method(
            "${name}f",
            sub {
                my ( $self, $format, @args ) = @_;

                if ( $self->level & $level ) {
                    $self->_log( $name, sprintf( $format, _flatten(@args) ) );
                }
            }
        );
    }

    # borrowed from CatalystX::Controller::Sugar

    sub _flatten {
        map {
                  ref $_     ? Data::Dumper::Dumper($_)
                : defined $_ ? $_
                : '__UNDEF__'
        } @_;
    }
}

no Moose::Role;

1;

