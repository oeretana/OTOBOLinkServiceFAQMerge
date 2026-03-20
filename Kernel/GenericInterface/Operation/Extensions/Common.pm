# --
# Copyright (C) 2026 INTELICOLAB
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Extensions::Common;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}

=head2 ValidateRequiredParams()

Validate that all required parameters are present in the data hash.

    my $Result = $CommonObject->ValidateRequiredParams(
        Data     => \%Data,
        Required => [ 'Object', 'Key' ],
    );

Returns:
    { Success => 1 }
or:
    { Success => 0, MissingParameter => 'ParamName' }

=cut

sub ValidateRequiredParams {
    my ( $Self, %Param ) = @_;

    my $Data     = $Param{Data}     || {};
    my $Required = $Param{Required} || [];

    for my $ParamName ( @{$Required} ) {
        if ( !defined $Data->{$ParamName} || $Data->{$ParamName} eq '' ) {
            return {
                Success          => 0,
                MissingParameter => $ParamName,
            };
        }
    }

    return { Success => 1 };
}

1;
