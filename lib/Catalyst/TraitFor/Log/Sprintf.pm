package Catalyst::TraitFor::Log::Sprintf;

use 5.008001;

use Moose::Role;

{
    my $meta = Class::MOP::get_metaclass_by_name(__PACKAGE__);

    while ( my ( $name, $level ) = each %Catalyst::Log::LEVELS ) {

        $meta->add_method(
            "${name}f",
            sub {
                my ( $self, $format, @args ) = @_;

                if ( $self->level & $level ) {
                    $self->_log(
                        $name,
                        @args ? sprintf( $format, @args ) : $format    #
                    );
                }
            }
        );
    }
}

no Moose::Role;

1;

