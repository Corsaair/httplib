package net.http.web
{
    import C.stdlib.getenv;

    /**
     * Where we store all Apache Environment variables
     *   - the non-standard ones like SERVER_SIGNATURE
     *   - the HTPP standard one too like HTTP_HOST
     * 
     * The goal is to be able to access those informations
     * even before building a request or a response.
     */
    public class ApacheEnvironment
    {
        
        private static const CONTEXT_DOCUMENT_ROOT:String = "CONTEXT_DOCUMENT_ROOT";
        private static const CONTEXT_PREFIX:String = "CONTEXT_PREFIX";
        private static const DOCUMENT_ROOT:String = "DOCUMENT_ROOT";
        private static const REDIRECT_QUERY_STRING:String = "REDIRECT_QUERY_STRING";
        private static const REDIRECT_STATUS:String = "REDIRECT_STATUS";
        private static const REDIRECT_URL:String = "REDIRECT_URL";
        private static const REQUEST_SCHEME:String = "REQUEST_SCHEME";
        private static const REQUEST_URI:String = "REQUEST_URI";
        private static const SCRIPT_FILENAME:String = "SCRIPT_FILENAME";
        private static const SERVER_ADDR:String = "SERVER_ADDR";
        private static const SERVER_ADMIN:String = "SERVER_ADMIN";
        private static const SERVER_SIGNATURE:String = "SERVER_SIGNATURE";
        
        private static const HTTP_ACCEPT:String = "HTTP_ACCEPT";
        private static const HTTP_ACCEPT_ENCODING:String = "HTTP_ACCEPT_ENCODING";
        private static const HTTP_ACCEPT_LANGUAGE:String = "HTTP_ACCEPT_LANGUAGE";
        private static const HTTP_CACHE_CONTROL:String = "HTTP_CACHE_CONTROL";
        private static const HTTP_CONNECTION:String = "HTTP_CONNECTION";
        private static const HTTP_COOKIE:String = "HTTP_COOKIE";
        private static const HTTP_HOST:String = "HTTP_HOST";
        private static const HTTP_REFERER:String = "HTTP_REFERER";
        private static const HTTP_USER_AGENT:String = "HTTP_USER_AGENT";
        
        
        private var _contextDocumentRoot:String = "";
        private var _contextPrefix:String       = "";
        private var _documentRoot:String        = "";
        private var _redirectQueryString:String = "";
        private var _redirectStatus:String      = "";
        private var _redirectURL:String         = "";
        private var _requestScheme:String       = "";
        private var _requestURI:String          = "";
        private var _scriptFilename:String      = "";
        private var _serverAddress:String       = "";
        private var _serverAdmin:String         = "";
        private var _serverSignature:String     = "";
        
        private var _httpAccept:String          = "";
        private var _httpAcceptEncoding:String  = "";
        private var _httpAcceptLanguage:String  = "";
        private var _httpCacheControl:String    = "";
        private var _httpConnection:String      = "";
        private var _httpCookie:String          = "";
        private var _httpHost:String            = "";
        private var _httpReferer:String         = "";
        private var _httpUserAgent:String       = "";
        
        public function ApacheEnvironment()
        {
            super();
            
            _ctor();
        }
        
        private function _ctor():void
        {
            try
            {
                _contextDocumentRoot = getenv( CONTEXT_DOCUMENT_ROOT );
                _contextPrefix       = getenv( CONTEXT_PREFIX );
                _documentRoot        = getenv( DOCUMENT_ROOT );
                _redirectQueryString = getenv( REDIRECT_QUERY_STRING );
                _redirectStatus      = getenv( REDIRECT_STATUS );
                _redirectURL         = getenv( REDIRECT_URL );
                _requestScheme       = getenv( REQUEST_SCHEME );
                _requestURI          = getenv( REQUEST_URI );
                _scriptFilename      = getenv( SCRIPT_FILENAME );
                _serverAddress       = getenv( SERVER_ADDR );
                _serverAdmin         = getenv( SERVER_ADMIN );
                _serverSignature     = getenv( SERVER_SIGNATURE );
                
                _httpAccept          = getenv( HTTP_ACCEPT );
                _httpAcceptEncoding  = getenv( HTTP_ACCEPT_ENCODING );
                _httpAcceptLanguage  = getenv( HTTP_ACCEPT_LANGUAGE );
                _httpCacheControl    = getenv( HTTP_CACHE_CONTROL );
                _httpConnection      = getenv( HTTP_CONNECTION );
                _httpCookie          = getenv( HTTP_COOKIE );
                _httpHost            = getenv( HTTP_HOST );
                _httpReferer         = getenv( HTTP_REFERER );
                _httpUserAgent       = getenv( HTTP_USER_AGENT );
            }
            catch( e:Error )
            {
                /* Note:
                see: Buffer Overflow via Environment Variables
                https://www.owasp.org/index.php/Buffer_Overflow_via_Environment_Variables
                
                Accessing an environment variable could create a buffer overflow
                so we wrap getenv() calls in a try/catch
                */
            }
        }
        
        public function get contextDocumentRoot():String { return _contextDocumentRoot; }
        public function get contextPrefix():String { return _contextPrefix; }
        public function get documentRoot():String { return _documentRoot; }
        public function get redirectQueryString():String { return _redirectQueryString; }
        public function get redirectStatus():String { return _redirectStatus; }
        public function get redirectURL():String { return _redirectURL; }
        public function get requestScheme():String { return _requestScheme; }
        public function get requestURI():String { return _requestURI; }
        public function get scriptFilename():String { return _scriptFilename; }
        public function get serverAddress():String { return _serverAddress; }
        public function get serverAdmin():String { return _serverAdmin; }
        public function get serverSignature():String { return _serverSignature; }
        
        public function get httpAccept():String { return _httpAccept; }
        public function get httpAcceptEncoding():String { return _httpAcceptEncoding; }
        public function get httpAcceptLanguage():String { return _httpAcceptLanguage; }
        public function get httpCacheControl():String { return _httpCacheControl; }
        public function get httpConnection():String { return _httpConnection; }
        public function get httpCookie():String { return _httpCookie; }
        public function get httpHost():String { return _httpHost; }
        public function get httpReferer():String { return _httpReferer; }
        public function get httpUserAgent():String { return _httpUserAgent; }
        
        public function toString():String
        {
            var str:String = "";
            
                str += CONTEXT_DOCUMENT_ROOT + " = " + contextDocumentRoot + "\n";
                str += CONTEXT_PREFIX + " = " + contextPrefix + "\n";
                str += DOCUMENT_ROOT + " = " + documentRoot + "\n";
                str += REDIRECT_QUERY_STRING + " = " + redirectQueryString + "\n";
                str += REDIRECT_STATUS + " = " + redirectStatus + "\n";
                str += REDIRECT_URL + " = " + redirectURL + "\n";
                str += REQUEST_SCHEME + " = " + requestScheme + "\n";
                str += REQUEST_URI + " = " + requestURI + "\n";
                str += SCRIPT_FILENAME + " = " + scriptFilename + "\n";
                str += SERVER_ADDR + " = " + serverAddress + "\n";
                str += SERVER_ADMIN + " = " + serverAdmin + "\n";
                str += SERVER_SIGNATURE + " = " + serverSignature + "\n";
            
                str += HTTP_ACCEPT + " = " + httpAccept + "\n";
                str += HTTP_ACCEPT_ENCODING + " = " + httpAcceptEncoding + "\n";
                str += HTTP_ACCEPT_LANGUAGE + " = " + httpAcceptLanguage + "\n";
                str += HTTP_CACHE_CONTROL + " = " + httpCacheControl + "\n";
                str += HTTP_CONNECTION + " = " + httpConnection + "\n";
                str += HTTP_COOKIE + " = " + httpCookie + "\n";
                str += HTTP_HOST + " = " + httpHost + "\n";
                str += HTTP_REFERER + " = " + httpReferer + "\n";
                str += HTTP_USER_AGENT + " = " + httpUserAgent + "\n";
            
            return str;
        }
    }
}