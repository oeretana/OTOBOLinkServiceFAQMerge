# --
# Copyright (C) 2026 INTELICOLAB
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Service::ServiceSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::GenericInterface::Operation::Common);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(%Param);

    return $Self->ReturnError(
        ErrorCode    => 'ServiceSearch.AuthFail',
        ErrorMessage => 'ServiceSearch: Could not authenticate.',
    ) if !$UserID;

    # Build search params — only include what was provided.
    my %SearchParams = (
        UserID => $UserID,
    );

    if ( defined $Param{Data}{Name} && $Param{Data}{Name} ne '' ) {
        $SearchParams{Name} = $Param{Data}{Name};
    }

    if ( defined $Param{Data}{Limit} && $Param{Data}{Limit} ne '' ) {
        $SearchParams{Limit} = $Param{Data}{Limit};
    }

    my @ServiceIDs = $Kernel::OM->Get('Kernel::System::Service')->ServiceSearch(
        %SearchParams,
    );

    return {
        Success => 1,
        Data    => {
            ServiceIDs => \@ServiceIDs,
        },
    };
}

1;
