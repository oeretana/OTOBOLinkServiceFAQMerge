# --
# Copyright (C) 2026 INTELICOLAB
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Service::ServiceGet;

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
        ErrorCode    => 'ServiceGet.AuthFail',
        ErrorMessage => 'ServiceGet: Could not authenticate.',
    ) if !$UserID;

    # Validate required params.
    my $ServiceID = $Param{Data}{ServiceID};

    return $Self->ReturnError(
        ErrorCode    => 'ServiceGet.MissingParameter',
        ErrorMessage => 'ServiceGet: ServiceID is required.',
    ) if !$ServiceID;

    my %ServiceData = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
        ServiceID => $ServiceID,
        UserID    => $UserID,
    );

    return $Self->ReturnError(
        ErrorCode    => 'ServiceGet.NotFound',
        ErrorMessage => "ServiceGet: Service with ID $ServiceID not found.",
    ) if !%ServiceData || !$ServiceData{ServiceID};

    return {
        Success => 1,
        Data    => {
            Service => \%ServiceData,
        },
    };
}

1;
