httplib
=======

A simple and efficient HTTP library for ActionScript 3.0 which
should lead to some more advanced and interesting code.


Here the focus is on the parsing of raw HTTP into structured objects
and the opposite, from Object to well-formed HTTP.

This is the result of an earlier prototype which has been tested
under Apache + CGI to serve the web site [burrrn.com](htttp://www.burrrn.com).

For the time being this library will encompass everything under
the `net` package: `net.http`, `net.http.cgi`, etc.

When mature enough we will split the components in their
respective libraries.

What to Expect ?
----------------

  - serve/answer HTTP requests/responses under CGI
  - small http client like curl, httpie
  - basic http server that can proxy to Apache  
    (like you would do with node.js)

Quick Test
----------

Create a symlink of redbean at the root of the project  
`$ ln -s /sdk/redtamarin/bin/redbean redbean`

Build the library  
`./redbean`

Run the testg with as3shebang  
`./test_httplib`

