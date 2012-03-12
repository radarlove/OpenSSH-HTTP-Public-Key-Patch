.. include:: <s5defs.txt>

OpenSSH HTTP Patch
==================

:Authors: Rich Liming
:Date: 3/11/2012

..  footer:: Rich Liming

What's here
-----------

A patch to SSH Server to support the retreival of public keys via an
HTTP URL for centralized key management.  A demo application implementing
port-knocking.

What's the point
----------------

To provide centralized, and more flexible and sophisticated SSH based 
authentication and key management by allowing SSH server to retreive 
public keys from a URL.  Since the URL can be either a static file
or dynamic content, any logic (subdomain, time of day, port knocking, 
etc)  can be used to selectively return the public key and thus grant or 
deny access from a central webserver.

What is the OpenSSH HTTP Patch
------------------------------

Using keys instead of password logins provides enhanced security, 
however public keys often need to be copied to every host
computer that a person requires access too.  Moreover, they also
need to be found and removed when that access needs to be revoked.

This patch provides, through the OpenSSH server's configuration file,
the ability to specify an HTTP or HTTPS URL where the SSH server will look
for public key files, allowing access to be controlled by placing
keys at a URL specified in the server config.

These two directives are needed to configure key retrieval via HTTP

OpenSSH Server Config (sshd.conf)
---------------------------------

::

HTTP_keys On
HTTP_URL https://example.com/pubkeys


This URL is a base URL.  If user 'mcfly' tries to login then the OpenSSH
server will look for his public key at https://example.com/pubkeys/mcfly

The URL can be HTTP or HTTPS.  The file can be static, or the result
of a dynamic web application or CGI script.

Port-Knocking Example
---------------------

A webserver is configured with a DocumentRoot of /var/www/html.  
Two directories are created /var/www/html/pubkeys and 
/var/www/html/keysallowed.  A web accessible script is written 
that when accessed will copy a public key from /var/www/html/pubkeys 
to /var/www/html/keysallowed.

The SSH server is configured (e.g. /etc/ssh/sshd_config)::

HTTP_keys On
HTTP_URL http://example.com/keysallowed

A cronjob is created that runs every five minutes and deletes all files
in /var/www/html/keysallowed. 

With this mechanism in place, SSH logins, even for people with configured
SSH keys will be denied by default.  However, if the person visits a 
URL such as http://example.com/opensesame.php?helloanybodyhome=<username>. 
If the username is 'mcfly' then user mcfly's key will be copied to the 
keysallowed/ directory and he will have some amount of time that is less 
than 5 minutes in which to login in via SSH.

McFly can stay logged in if his key is deleted with in a few minutes, or
knock again.
