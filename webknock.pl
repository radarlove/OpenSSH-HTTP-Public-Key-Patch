#!/usr/bin/perl
#
# OpenSSH HTTP Patch - webknock.pl
# Web-knocking example code

use CGI qw/:standard/;

$base_dir = '/var/www/html';
$allow_dir = "$base_dir/allowedkeys";
$store_dir = "$base_dir/pubkeys";
$user = param('user');
$keypath = "$store_dir/$user";

print header, start_html('Web Knocker');

if (($user) and ($user =~ /[a-zA-Z]/)) {
    if (-f $keypath) {
        $cmd = "ln -sf $keypath $allow_dir/$user";
        `$cmd`;
        if ($? != 0) {
            $msg = 'Error';
        }else {
            $msg = "Thanks $user, you can now login";
        }
    }else {
        $msg = "Invalid user :$user:$keypath";
    }
}else {
    print
        start_form,
        "What's your userid?",
        textfield('user'),
        submit,
        endform;
}

print $msg, end_html;
