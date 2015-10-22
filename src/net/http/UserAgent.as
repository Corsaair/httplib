package net.http
{
    /* Note:
    
       see: https://developer.mozilla.org/en-US/docs/Web/HTTP/Gecko_user_agent_string_reference Gecko user agent string reference
       see: https://developer.mozilla.org/en-US/docs/Browser_detection_using_the_user_agent Browser detection using the user agent
       see: https://en.wikipedia.org/wiki/User_agent
       see: http://tools.ietf.org/html/rfc7231#section-5.5.3 - HTTP/1.1 5.5.3. User-Agent
       see: http://user-agents.me/
    
       see: https://github.com/ua-parser/uap-core BrowserScope's original user agent string parser regexes
    
       example:
       User-Agent: CERN-LineMode/2.15 libwww/2.17b3
    
       var ua:UserAgent = new UserAgent( "CERN-LineMode", "2.15" );
           ua.addToken( "libwww", "2.17b3" );
    
       more example:
    
       Safari on an iPad
       Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405
    
       Google Bot
       Googlebot/2.1 (+http://www.google.com/bot.html)
    
    
       Also UA in relation with Sessions
    
       see: https://www.eff.org/deeplinks/2010/01/tracking-by-user-agent Browser Versions Carry 10.5 Bits of Identifying Information on Average
    
       for ex we could craft a special session management
       that would uniquely identify a user by
       - the User-Agent
       - the IP Address
       - other (the Accept-Language for ex)
       without the need to rely on a client-side cookie to store this "unique id"
    
       eg.
       var id = hash( user-agent : ip-address : language );
    */
    public class UserAgent
    {
        private var _token:Array;
        
        public function UserAgent( productName:String = "",
                                   productVersion:String = "",
                                   productComment:String = "" )
        {
            super();
            
            _token = [];
            addToken( productName, productVersion, productComment );
        }
        
        public function addToken( name:String,
                                  version:String = "",
                                  comment:String = "" ):void
        {
            if( name != "" )
            {
                var token:Object = {};
                    token.name    = name;
                    token.version = version;
                    token.comment = comment;
                
                _token.push( token );
            }
        }
        
        public function toHeader():Header
        {
            var header:HttpHeader = new HttpHeader( HttpHeader.USER_AGENT,
                                                    this.toString() );
            return header;
        }
        
        public function toString():String
        {
            var products:Array = [];
            
            var i:uint;
            var len:uint = _token.length;
            var token:Object;
            var product:String;
            for( i = 0; i < len; i++ )
            {
                token = _token[i];
                product = token.name;
                
                if( token.version != "" )
                {
                    product += "/" + token.version;
                }
                
                if( token.comment != "" )
                {
                    product += " (" + token.comment + ")";
                }
                products.push( product );
            }
            
            return products.join( " " );
        }
    }
}