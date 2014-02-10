package NGS::Tools::Mutect;
use Moose;
use MooseX::Params::Validate;

with 'NGS::Tools::Mutect::Role';

use 5.006;
use strict;
use warnings FATAL => 'all';

=head1 NAME

NGS::Tools::Mutect - The great new NGS::Tools::Mutect!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

A class containing methods to run the Mutect somatic calling algorithm.  This utilities Mutect Moose Roles found in this package.

    use NGS::Tools::Mutect;

    my $obj = NGS::Tools::Mutect->new();
    ...

=head1 SUBROUTINES/METHODS

=head2 $obj->BUILD()

Post-constructor initialization (called automatically as part of new())

=cut

sub BUILD {
	my $self = shift;
	my $args = shift;
	}

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at sickkids.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ngs-tools-mutect at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NGS-Tools-Mutect>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::Mutect


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NGS-Tools-Mutect>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NGS-Tools-Mutect>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NGS-Tools-Mutect>

=item * Search CPAN

L<http://search.cpan.org/dist/NGS-Tools-Mutect/>

=back


=head1 ACKNOWLEDGEMENTS

Dr. Adam Shlien, PI -- The Hospital for Sick Children

Dr. Roland -- The Hospital for Sick Children

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

no Moose;

__PACKAGE__->meta->make_immutable;

1; # End of NGS::Tools::Mutect
