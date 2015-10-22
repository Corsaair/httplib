/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
include "net/URIResolver.as";
include "net/URIEncoding.as";
include "net/URI.as";

include "net/http/HttpConnection.as";
include "net/http/HttpHeader.as";
include "net/http/HttpMessage.as";
include "net/http/HttpMethod.as";
include "net/http/HttpRequest.as";
include "net/http/HttpResponse.as";
include "net/http/HttpUtils.as";
*/

include "net/mediatypes/MediaType.as";
include "net/mediatypes/application/BINARY.as";
include "net/mediatypes/text/TEXT.as";
include "net/mediatypes/text/TEXT_UTF8.as";
include "net/mediatypes/text/HTML.as";
include "net/mediatypes/text/HTML_UTF8.as";

include "net/mediatypes/image/PNG.as";

include "net/URIResolver.as";
include "net/URIEncoding.as";
include "net/URI.as";

include "net/http/Header.as";
include "net/http/Request.as";
include "net/http/Response.as";
include "net/http/Environment.as";
include "net/http/Configuration.as";
include "net/http/Gateway.as";

include "net/http/StatusCode.as";
include "net/http/RequestMethod.as";
include "net/http/Cookie.as";

include "net/http/HttpConfig.as";
include "net/http/HttpConnection.as";
include "net/http/HttpHeader.as";
include "net/http/HttpMessage.as";
include "net/http/HttpRequest.as";
include "net/http/HttpResponse.as";
include "net/http/HttpAuthentication.as";
include "net/http/HttpUtils.as";

include "net/http/router/Router.as";
include "net/http/router/Route.as";
include "net/http/router/Rule.as";
include "net/http/router/routes/CommonRoute.as";
include "net/http/router/routes/RegExpRoute.as";
include "net/http/router/rules/StaticRule.as";
include "net/http/router/rules/RegExpRule.as";
include "net/http/router/rules/NotFoundRule.as";

include "net/http/cgi/MetaVariables.as";
include "net/http/cgi/CommonConfig.as";
include "net/http/cgi/CommonEnvironment.as";
include "net/http/cgi/CommonRequest.as";
include "net/http/cgi/CommonResponse.as";
include "net/http/cgi/CommonGateway.as";
include "net/http/cgi/CommonRouter.as";

include "net/http/responses/TextResponse.as";
include "net/http/responses/HTMLResponse.as";
include "net/http/responses/ByteArrayResponse.as";
include "net/http/responses/HTMLTemplateResponse.as";

include "net/http/sessions/Session.as";
include "net/http/sessions/SessionStorage.as";
include "net/http/sessions/SessionStatus.as";
include "net/http/sessions/FileSession.as";
include "net/http/sessions/FileSessionStorage.as";
include "net/http/sessions/SessionManager.as";

include "net/http/web/WebConfig.as";
include "net/http/web/ApacheEnvironment.as";
include "net/http/web/WebGateway.as";
include "net/http/web/WebPage.as";
include "net/http/web/WebModule.as";

// text.html
include "_global.as";
include "scriptname.as";
include "text/html/TemplateEngine.as";

"httplib 0.4";