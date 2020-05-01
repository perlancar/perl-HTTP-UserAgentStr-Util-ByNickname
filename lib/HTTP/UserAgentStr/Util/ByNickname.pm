package HTTP::UserAgentStr::Util::ByNickname;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

our @nicknames = qw(
                       newest_firefox
                       newest_firefox_linux
                       newest_firefox_win
                       newest_chrome
                       newest_chrome_linux
                       newest_chrome_win
               );

use Exporter qw(import);
our @EXPORT_OK = @nicknames;
our %EXPORT_TAGS = (all => \@nicknames);

sub _get {
    require HTTP::BrowserDetect;
    require Versioning::Scheme::Dotted;
    require WordList::HTTP::UserAgentString::Browser::Firefox;

    my $nickname = shift;

    my @ua0;
    my $wl = WordList::HTTP::UserAgentString::Browser::Firefox->new;
    $wl->each_word(
        sub {
            my $orig = shift;
            my $ua = HTTP::BrowserDetect->new($orig);
            push @ua0, {
                orig => $orig,
                os => $ua->os,
                firefox => $ua->firefox,
                chrome => $ua->chrome,
                version => $ua->browser_version || '0.0',
            };
        });
    #use DD; dd \@ua0;

    my @ua;
    if ($nickname eq 'newest_firefox') {
        my $os = $^O eq 'MSWin32' ? 'windows' : 'linux';
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{firefox} && ($_->{os}//'') eq $os } @ua0;
    } elsif ($nickname eq 'newest_firefox_linux') {
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{firefox} && ($_->{os}//'') eq 'linux' } @ua0;
    } elsif ($nickname eq 'newest_firefox_win') {
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{firefox} && ($_->{os}//'') eq 'windows' } @ua0;
    } elsif ($nickname eq 'newest_chrome') {
        my $os = $^O eq 'MSWin32' ? 'windows' : 'linux';
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{chrome} && ($_->{os}//'') eq $os } @ua0;
    } elsif ($nickname eq 'newest_chrome_linux') {
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{chrome} && ($_->{os}//'') eq 'linux' } @ua0;
    } elsif ($nickname eq 'newest_chrome_win') {
        @ua = sort { Versioning::Scheme::Dotted->cmp_version($b->{version}, $a->{version}) }
            grep { $_->{chrome} && ($_->{os}//'') eq 'windows' } @ua0;
    } else {
        die "BUG: Unknown nickname";
    }

    $ua[0]{orig};
}

sub newest_firefox { _get("newest_firefox") }
sub newest_firefox_linux { _get("newest_firefox_linux") }
sub newest_firefox_win { _get("newest_firefox_win") }
sub newest_chrome { _get("newest_chrome") }
sub newest_chrome_linux { _get("newest_chrome_linux") }
sub newest_chrome_win { _get("newest_chrome_win") }

1;
# ABSTRACT: Get popular HTTP User-Agent string by nickname

=head1 SYNOPSIS

 use HTTP::UserAgentStr::Util::ByNickname qw(
                       newest_firefox
                       newest_firefox_linux
                       newest_firefox_win
                       newest_chrome
                       newest_chrome_linux
                       newest_chrome_win
 );

 say newest_firefox_linux();

Sample output (at the time of this writing):

 Mozilla/5.0 (X11; Linux x86_64; rv:66.0) Gecko/20100101 Firefox/66.0


=head1 DESCRIPTION

=head2 newest_firefox

=head2 newest_firefox_linux

=head2 newest_firefox_win

=head2 newest_chrome

=head2 newest_chrome_linux

=head2 newest_chrome_win


=head1 SEE ALSO
