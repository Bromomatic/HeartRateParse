use strict;
use warnings;
use XML::Simple qw(:strict);
use Data::Dumper;

my $xml = XMLin(
                'daito0.xml', 
                KeyAttr => { }, 
                ForceArray => [ 'Trackpoint' ],
                );

open (TEMP, '>hrm_temp.csv') or die "Cannot create hrm_temp.csv: $!";
#print TEMP Dumper($xml);

# Grab
my $max_heart_rate = $xml->{Activities}->{Activity}->{Lap}->{MaximumHeartRateBpm}->{Value};
my $avg_heart_rate = $xml->{Activities}->{Activity}->{Lap}->{AverageHeartRateBpm}->{Value};

# Trim
$max_heart_rate =~ s/^\s+|\s+$//g;
$avg_heart_rate =~ s/^\s+|\s+$//g;

print TEMP "Max,$max_heart_rate\n";
print TEMP "Avg,$avg_heart_rate\n";

my $index = 0;
for ( @{ $xml->{Activities}->{Activity}->{Lap}->{Track}->{Trackpoint} } ) {

    my $currbpm = $_->{HeartRateBpm}->{Value};

    if ( $currbpm ) {
        $currbpm =~ s/^\s+|\s+$//g;
        print TEMP "$index,$currbpm\n";
    }    
    
    $index++;

}

close TEMP;