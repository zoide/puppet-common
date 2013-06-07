#!/usr/bin/perl -ni

# $Id: file_splice.pl 1299 2008-05-12 14:55:08Z admin $

BEGIN {

	$SPLICE = shift @ARGV;
	$COMMENT_CHAR = shift @ARGV;
	$SECTION_PATTERN = shift @ARGV;

	$BEGIN_PATTERN = $COMMENT_CHAR . " BEGIN " . $SECTION_PATTERN;
	$END_PATTERN = $COMMENT_CHAR . " END " . $SECTION_PATTERN;

	$in_section     = 0;
	$spliced        = 0;

	sub output_splice() {
		print $BEGIN_PATTERN, "\n";
		open (SPLICE, "<$SPLICE");
		while(<SPLICE>) { print $_; }
		close (SPLICE);
		print $END_PATTERN, "\n";
		$spliced = 1;
	}
}

END {
	unless ($spliced) {
		output_splice();
	}
}


if (/$BEGIN_PATTERN/) {
	$in_section = 1;
	output_splice();
}
elsif (/$END_PATTERN/) {
	$in_section = 0;
}
elsif (!$in_section) {
	print;
}




