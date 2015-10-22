package net.http.cgi
{
    import C.errno.CError;
    import C.errno.errno;
    
    import flash.utils.ByteArray;
    
    import net.http.Configuration;
    import net.http.Environment;
    import net.http.Gateway;
    import net.http.Header;
    import net.http.HttpHeader;
    import net.http.HttpUtils;
    import net.http.Request;
    import net.http.RequestMethod;
    import net.http.Response;
    import net.http.StatusCode;
    import net.mediatypes.text.TEXT_UTF8;
    
    import shell.Program;
    
    /**
     * A Common Gateway Interface (CGI) implementation.
     * 
     */ 
    public class CommonGateway implements Gateway
    {
        private var _env:Environment;
        private var _config:Configuration;
        private var _errors:String;
        
        protected var _destination:String;
        protected var _request:CommonRequest;
        
        public function CommonGateway( config:Configuration = null ):void
        {
            super();
            
            if( !config )
            {
                var commonconf:CommonConfig = new CommonConfig();
                config = commonconf;
            }
            
            _env         = null;
            _config      = config;
            _errors      = "";
            _destination = "";
            _request     = null;
        }
        
        /* Generate the HTTP header "X-Powered-By: redtamarin/0.4.1T174"
        */
        private function _poweredByRedtamarin( value:String, response:Response ):Response
        {
            var res:CommonResponse = response as CommonResponse;
            var header:Header = new HttpHeader( HttpHeader.X_POWERED_BY, value );
            res.addHeader( header, true );
            
            return res;
        }
        
        /**
         * Build the destination or URL path of the gateway.
         */
        protected function buildDestination():String
        {
            /* We need to build a URL for the request
            and with CGI we can do that in 2 different way
            
            1. The Server POV
            a CGI script is called on the server
            we are one resource among others
            
            we know we are an HTTP server so we use the "http" protocol
            SERVER_NAME = www.as3lang.org
            SCRIPT_NAME = /index.abc
            
            to build the URL we are concatening those values 
            http:// + SERVER_NAME + SCRIPT_NAME
            
            we can have only 1 URL
            URL = http://www.as3lang.org/index.abc
            
            2. The CGI POV
            we are the end point called on the server
            to respond to different paths
            
            we know we are an HTTP server so we use the "http" protocol
            we will consider our SCRIPT_NAME to be the "root"
            SERVER_NAME = www.as3lang.org
            PATH_INFO = (can be many things)
            
            to build the URL we are basically ignoring the SCRIPT_NAME
            http:// + SERVER_NAME + PATH_INFO
            
            and then we can have many URL
            
            if the PATH_INFO is empty we are at the root eg. "/"
            URL = http://www.as3lang.org/
            
            if you try to visit
            http://www.as3lang.org/index.abc/test123/
            PATH_INFO = /test123/
            URL = http://www.as3lang.org/test123/
            
            Here the destination should only keep the path element of the URL
            in short
            
            1. server POV
            destination = SCRIPT_NAME
            
            2. CGI POV
            destination = PATH_INFO
            
            by default, we use the server POV
            eg. the CGI program is one resource among others
            and you could have different programs
            
            for ex:
            http://www.as3lang.org/index.abc
            http://www.as3lang.org/test.abc
            http://www.as3lang.org/some/path/calendar.abc
            etc.
            
            If you do some mod_rewrite and other redirects
            overwrite the getter to change the logic to use PATH_INFO
            
            example:
            override protected function buildDestination():String
            {
                 return _env.pathInfo;
            }
            */
            
            // server POV
            var dest:String = _env.scriptName;
            
            // CGI POV
            //var dest:String = _env.pathInfo;
            
            return dest;
        }
        
        /** @inheritDoc */
        public function get environment():Environment { return _env; }
        
        /** @inheritDoc */
        public function get config():Configuration { return _config; };
        
        /** @inheritDoc */
        public function get request():Request { return _request; }
        
        /** @inheritDoc */
        public function get errors():String { return _errors; }
        /** @private */
        public function set errors( value:String ):void { _errors = value; }
        
        /** @inheritDoc */
        public function get destination():String { return _destination; }
        /** @private */
        public function set destination( value:String ):void { _destination = value; }
        
        /** @inheritDoc */
        public function authorized():Boolean
        {
            /* By default, we want to authorize all requests
               when you inherit the Gateway override this method
               to check for specifics
               
               for ex:
               public override function authorized():Boolean
               {
                   if( environment.remoteAddress == "127.0.0.1" )
                   {
                       return true;
                   }
            
                   return false;
               }
            
               also you will need to do the check inside your apply() call
               for ex:
               public override function apply( request:Request ):Response
               {
                   if( authorized() )
                   {
                        // build a response with status = 200
                   }
                   else
                   {
                         // build an error response status = 401, 403, etc.
                   }
               }
            */
            return true;
        }
        
        /** @inheritDoc */
        public function onErrorCaught( e:Error ):void
        {
            /* By default we show a stacktrace of the error
               at the top of the response
            
               you may want to change that, if so override
               for example:
               public override function onErrorCaught( e:Error ):void
               {
                   // save the error to a log file for example
               }
            */
            // 0. generic message
            //errors += "an error occured\n";
            
            // 1. simple
            //errors += e.toString() + "\n";
            
            // 2. detailled
            errors += e.getStackTrace() + "\n";
            
            // 3. not really useful now but good to know
            //errors += Error.getErrorMessage( e.errorID ) + "\n";
        }
        
        /** @inheritDoc */
        public function onFailedResponse():Response
        {
            /* This is our default response when we failed
               to get a response.
            
               Our Gateway CAN NOT not send back a response.
            
               If you need a fancier default response you can override it
               example:
               public override function onFailedResponse():Response
               {
                    // your own response definition here
               }
            */
            var response:Response = new CommonResponse();
              //response.contentType = "text/plain; charset=utf-8";
                response.contentType = TEXT_UTF8.toString();
                //response.body = "nothing to display";
            
            return response;
        }
        
        /** @inheritDoc */
        public function onServerErrors( response:Response ):void
        {
            var commonconfig:CommonConfig = config as CommonConfig;
            
            /* If the server encountered an error we can use
               this decorator to modify the response
               and for example: change the status,
               add our own error message, etc.
            
               By default we will return an Error 500
               if you need to change that, override
               for example:
               public override function onServerErrors( response:Response ):void
               {
                   response.status = StatusCode.fromCode( "404" ).toString();
                   // etc.
               }
            */
            response.status = StatusCode.INTERNAL_SERVER_ERROR.toString();
            
            if( commonconfig.optionShowGatewayErrors )
            {
                response.body = errors + "\r\n" + response.body;    
            }
            
        }
        
        /** @inheritDoc */
        public function onMissingContentLength():void
        {
            // 411 Length Required
            var response:Response = onFailedResponse();
                response.status = StatusCode.LENGTH_REQUIRED.toString();
            
            output( response );
        }
        
        /** @inheritDoc */
        public function onRequestBodyTooBig():void
        {
            // 413 Payload Too Large
            var response:Response = onFailedResponse();
                response.status = StatusCode.PAYLOAD_TOO_LARGE.toString();
            
            output( response );
        }
        
        /** @inheritDoc */
        public function onRequestLineTooBig():void
        {
            // 414 URI Too Long
            var response:Response = onFailedResponse();
            response.status = StatusCode.URI_TOO_LONG.toString();
            
            output( response );
        }
        
        /** @inheritDoc */
        public function onRequestHeadersTooMany():void
        {
            // 400 Bad Request
            var response:Response = onFailedResponse();
                response.status = StatusCode.BAD_REQUEST.toString();
            
            var commonconfig:CommonConfig = config as CommonConfig;
            
            if( commonconfig.stringHeadersTooMany != "" )
            {
                response.body = commonconfig.stringHeadersTooMany;
            }
            
            output( response );
        }
        
        /** @inheritDoc */
        public function onRequestHeaderSizeTooBig():void
        {
            // 400 Bad Request
            var response:Response = onFailedResponse();
                response.status = StatusCode.BAD_REQUEST.toString();
            
            var commonconfig:CommonConfig = config as CommonConfig;
            
            if( commonconfig.stringHeaderSizeTooBig )
            {
                response.body = commonconfig.stringHeaderSizeTooBig;
            }
                
            output( response );
        }
        
        /** @inheritDoc */
        public function run():void
        {
            /* We initialise the environment variables
               based on the CGI Meta-variables
            */
            _env = new CommonEnvironment();
            
            var commonconfig:CommonConfig = config as CommonConfig;
            
            //var missingContentLength:Boolean = false;
            
            var method:String  = _env.requestMethod;
            var cType:String   = _env.contentType;
            var cLength:String = _env.contentLength;
            var query:String   = _env.querySring;
            
            // dealing with POST data
            var post:ByteArray = new ByteArray();
            var len:Number     = parseInt( cLength );
            
            /* In CommonResponse you can see how
               we write to the standard output or stdout.
            
               Here we do the opposite,
               we read from the standard input or stdin
            
               at the condition that the method is POST/PUT
               and that the content-lenght is bigger than zero
            */
            if( (method == RequestMethod.POST) ||
                (method == RequestMethod.PUT) )
            {
                if( (cLength == "") &&
                    commonconfig.optionRequireContentLength )
                {
                    onMissingContentLength();
                    return;
                }
                
                if( len > commonconfig.limitRequestBody )
                {
                    onRequestBodyTooBig();
                    return;
                }
                
                if( len > 0 )
                {
                    var read:int = HttpUtils.read_post_body( post, uint(len) );
                    if( read < 0 )
                    {
                        //an error occured
                        var cerr:CError = new CError( "", errno );
                        errors += cerr.toString() + "\n";
                    }              
                }
                /*
                else if( !commonconfig.optionRequireContentLength )
                {
                    //ATTENTION: it is dangerous to do that!!!
                    var readall:uint = HttpUtils.read_post_raw( post );
                    if( readall < 0 )
                    {
                        //an error occured
                        var cerr:CError = new CError( "", errno );
                        errors += cerr.toString() + "\n";
                    }
                }
                */
            }
            
            // we prepare a response
            var response:Response;
            
            /* From the environment variables
               we also grab all the vars starting with "HTTP_"
            */
            var environ:Array = [];
            try
            {
                environ = Program.environ;
            }
            catch( e:Error )
            {
                /* Note:
                   see: Buffer Overflow via Environment Variables
                        https://www.owasp.org/index.php/Buffer_Overflow_via_Environment_Variables
                
                   Accessing an environment variable could create a buffer overflow
                   so we wrap Program.environ in a try/catch
                */
            }
            
            var headers:Array = HttpUtils.environ_http_headers( environ,
                                                                "HTTP_",
                                                                commonconfig.limitRequestHeaders,
                                                                commonconfig.limitRequestHeaderSize,
                                                                this );
            
            if( !headers )
            {
                /* Note:
                   headers are null (not empty)
                   so that means an error occured
                   and we can stop processing the request
                */
                return;
            }
            
            // we try build the request path if this one is empty
            if( _destination == "" )
            {
                _destination = buildDestination();    
            }
            
            //build the request line
            var requestLine:String = method + " " + destination;
            if( query != "" )
            {
                requestLine += "?" + query;
            }
                requestLine += " HTTP/1.1";
            
            if( (commonconfig.limitRequestLine != 0) &&
                (requestLine.length > commonconfig.limitRequestLine) )
            {
                onRequestLineTooBig();
                return;
            }
            
            // with all these informations we build a request object
            _request = new CommonRequest( method, cType, destination, query, headers, post );
            
            /* IMPORTANT:
               We have to catch errors,
               but we have to do it without
               upseting the CGI way of doing things.
               
               Because of CGI we can not trace() or
               throw errors anywhere in our code as
               it would disturb the way we write the
               response and almost certainly cause the
               server to generate an Error 500.
            
               But we do want to catch errors in our
               code because it can happen and if it
               does we want to know what caused it and
               where, so to do that we store the error.
            */
            try
            {
                response = apply( request );
            }
            catch( e:Error )
            {
                onErrorCaught( e );
            }
            
            /* If we failed to obtain a response
               we need to build a default one
            */
            if( response == null )
            {
                response = onFailedResponse();
                
                if( commonconfig.stringDefaultFailedResponseBody != "" )
                {
                    response.body = commonconfig.stringDefaultFailedResponseBody;
                }
            }
            
            /* IMPORTANT:
               If some errors occured
               we highjack the response
               and place it above the content.
            
               Here it is important to make the
               difference between an Error 500
               created by the server, and one
               created by the our gateway (what we do here).
            
               For now we keep it simple, but
               the logic could be more complicated,
               for example check the remote IP address
               and block/allow the content based on that.
            */
            if( errors != "" )
            {
                onServerErrors( response );
            }
            
            /* If at this point the request is still not
               attached to the response then we attach it
            */
            if( !response.httpRequest )
            {
                response.httpRequest = _request;
            }
            
            output( response );
        }
        
        /** @inheritDoc */
        public function apply( request:Request ):Response
        {
            // by default our gateway has no logic and so returns nothing
            return null;
        }
                
        /** @inheritDoc */
        public function output( response:Response ):void
        {
            var commonconfig:CommonConfig = config as CommonConfig;
            
            if( commonconfig.optionShowPoweredByRedtamarin )
            {
                var value:String = commonconfig.stringPoweredByRedtamarin;
                response = _poweredByRedtamarin( value, response );
            }
            
            /* We write the response content stream
            to the output, eg. we flush all data to stdout
            */
            var stream:CommonResponse = response as CommonResponse;
                stream.display();
                stream.flush();
        }
        
    }
    
}