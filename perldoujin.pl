#!/usr/bin/env perl

use LWP::Simple;
use Getopt::Long;
use File::Spec;

# Default values
my $id = '0';
my $directory = ".";

# Parse opts
GetOptions('id=s' => \$id, 'dir=s' => \$directory);
$directory = File::Spec->rel2abs($directory) ."/";

die "Please enter an id. (--id=<num>)\n" if $id eq '0';

# Useful stuff
my $url = 'http://thedoujin.com/index.php/pages/%d?Pages_page=%d';
my $image_url = 'http://thedoujin.com/images/%s/%s';
my $last_image = '';
my $page = 1;

print "Hold on, I got this...\n";

while(1) {
	my $html = get(sprintf($url, $id, $page));

	if($html =~ m/http:\/\/thedoujin.com\/images\/(\d+)\/(.*?)\?/g) {
		$image = sprintf($image_url, $1, $2); # Build the image URL
		my ($ext) = $image =~ /(\.[^.]+)$/;

		last if $image eq $last_image; # Make sure we have a new image

		$last_image = $image;
		getstore($image, $directory . $id ."_". $page . $ext); # Save image
	}

	$page++; # Onward!
}

print "... and done!";