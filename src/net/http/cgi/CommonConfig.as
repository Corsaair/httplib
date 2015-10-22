package net.http.cgi
{
    import net.http.HttpConfig;
    
    import shell.Runtime;
    
    public class CommonConfig extends HttpConfig
    {
        
        /* Gateway Limits */
        
        /**
         * Maximum data in bytes accepted in a request message body
         * (mostly POST/PUT requests).
         * 
         * <p>
         * By default we can support a maximum of 2GB (MAX_INT),
         * or 2147483647 bytes.
         * This is imposed by the fread() function when reading from stdin.
         * If the data is bigger the server should returns
         * a <code>413 Payload Too Large</code>.
         * </p>
         * 
         * <p>
         * You can not disable this limit by setting it to <code>0</code> (zero),
         * if you do this it will block any POST/PUT request.
         * </p>
         * 
         * <p>
         * This can gives you greater control over abnormal client request
         * behavior, which may be useful for avoiding some forms of
         * denial-of-service attacks.
         * </p>
         */ 
        public var limitRequestBody:uint = int.MAX_VALUE;
        
        /**
         * Maximum request line length in bytes accepted in ANY requests.
         * 
         * <p>
         * The request line include the method and the URI path plus the query
         * string. eg. <code>GET /some/path?a=1&#38;b=2</code>.
         * </p>
         * 
         * <p>
         * Self-imposed limit default to 8KB, or 8192 bytes
         * (as we could support any size really).
         * If the request line is bigger the server should returns
         * a <code>414 URI Too Long</code>.
         * </p>
         * 
         * <p>
         * To disable this limit set it to <code>0</code> (zero).
         * </p>
         * 
         * <p>
         * This can gives you greater control over abnormal client request
         * behavior, which may be useful for avoiding some forms of
         * denial-of-service attacks.
         * </p>
         */
        public var limitRequestLine:uint = 8192;
        
        /**
         * Maximum number of headers supported in a request.
         * 
         * <p>
         * Self-imposed limit default to 100.
         * If there are more than 100 headers the server should returns
         * a <code>400 Bad Request</code>.
         * </p>
         * 
         * <p>
         * To disable this limit set it to <code>0</code> (zero).
         * </p>
         * 
         * <p>
         * This can gives you greater control over abnormal client request
         * behavior, which may be useful for avoiding some forms of
         * denial-of-service attacks.
         * </p>
         */
        public var limitRequestHeaders:uint = 100;
        
        /**
         * Maximum size in bytes of a HTTP header supported in a request.
         * 
         * <p>
         * Self-imposed limit default to 8KB, or 8192 bytes.
         * If the header size is bigger the server should returns
         * a <code>400 Bad Request</code>.
         * </p>
         * 
         * <p>
         * To disable this limit set it to <code>0</code> (zero).
         * </p>
         * 
         * <p>
         * This can gives you greater control over abnormal client request
         * behavior, which may be useful for avoiding some forms of
         * denial-of-service attacks.
         * </p>
         */
        public var limitRequestHeaderSize:uint = 8192;
        
        
        /* Gateway Strings */
        
        /**
         * The default body of a failed response.
         * 
         * <p>
         * If you do not want to provide details, set it to the empty string.
         * </p>
         */ 
        public var stringDefaultFailedResponseBody:String = "Nothing to display.";
        
        /**
         * The body of a "Too many headers" failed response.
         * 
         * <p>
         * If you do not want to provide details, set it to the empty string.
         * </p>
         */ 
        public var stringHeadersTooMany:String = "There are too many headers to process.";
        
        /**
         * The body of a "header size is too big" failed response.
         * 
         * <p>
         * If you do not want to provide details, set it to the empty string.
         * </p>
         */ 
        public var stringHeaderSizeTooBig:String = "Some headers are too big to process.";
        
        /**
         * The value for the header "X-Powered-By".
         * 
         * <p>
         * If you want to provide less details, edit this string.
         * If you want to disable it completely see the option
         * <code>optionShowPoweredByRedtamarin</code>.
         * </p>
         */
        public var stringPoweredByRedtamarin:String = "redtamarin/" + Runtime.redtamarin;
        
        
        /* Gateway Options */
        
        /**
         * Allows to show the gateway error details in the response.
         * 
         * <p>
         * Such details as error names, error codes, stacktraces, etc.
         * could provide clues to potential attackers. 
         * </p>
         */
        public var optionShowGatewayErrors:Boolean = true;
        
        /**
         * Allows to show a "X-Powered-By" header for each response.
         * 
         * <p>
         * Example: <code>X-Powered-By: redtamarin/0.4.1T174</code>.
         * </p>
         * 
         * <p>
         * For security reasons, to avoid to reveal too much to a potential
         * attacker, you can either change the string by editing
         * <code>stringPoweredByRedtamarin = "redtamarin"</code>
         * (not providing the runtime version information, for example)
         * or completely disable this header by turning off this option.
         * </p>
         */
        public var optionShowPoweredByRedtamarin:Boolean = true;
        
        /**
         * Enable the server to refuse to accept POST/PUT requests without
         * a defined <code>Content-Length</code>.
         * 
         * <p>
         * If a <code>Content-Length</code> is not found the server should
         * returns a <code>411 Length Required</code>.
         * </p>
         * 
         * <p>
         * Even if we could parse a POST/PUT request without knowing in advance
         * its length, see <code>HttpUtils.read_post_raw()</code>, this could
         * lead to some buffer overflow and other denial of service, so we
         * avoid to do it.
         * </p>
         */ 
        public var optionRequireContentLength:Boolean = true;
        
        public function CommonConfig()
        {
            super();
        }
        
    }
}