use strict;
use warnings;

BEGIN {$ENV{T2_HARNESS_UI_ENV} = 'dev'}

use Plack::Builder;
use Plack::App::Directory;
use Plack::App::File;


builder {
    enable "DBIx::DisconnectAll";
    mount '/js'  => Plack::App::Directory->new({root => 'share/js'})->to_app;
    mount '/css' => Plack::App::Directory->new({root => 'share/css'})->to_app;
    mount '/img' => Plack::App::Directory->new({root => 'share/img'})->to_app;
    mount '/favicon.ico' => Plack::App::File->new({file => 'share/img/favicon.ico'})->to_app;

    mount '/' => sub {
        require Test2::Harness::UI;
        require Test2::Harness::UI::Config;

        my $config = Test2::Harness::UI::Config->new(
            dbi_dsn     => $ENV{HARNESS_UI_DSN},
            dbi_user    => '',
            dbi_pass    => '',
            single_user => 1,
            show_user   => 1,
        );

        Test2::Harness::UI->new(config => $config)->to_app->(@_);
    }
}
