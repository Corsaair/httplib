package net.http
{
    import flash.system.System;
    import flash.utils.describeType;
    
    import shell.FileSystem;
    
    /**
     * Our Http Configuration base class.
     */ 
    public class HttpConfig implements Configuration
    {
        public function HttpConfig()
        {
            super();
        }
        
        /**
         * Load an external JSON files
         * and merge the data into the <code>WebConfig</code> object.
         * 
         * @param filename the path to the JSON config file.
         */
        public function load( filename:String ):void
        {
            if( FileSystem.exists( filename ) )
            {
                var str:String = FileSystem.read( filename );
                var obj:Object = JSON.parse( str );
                
                if( obj )
                {
                    merge( obj );
                }
            }
        }
        
        /**
         * Merge the properties of a litteral object
         * into the <code>WebConfig</code> object.
         * 
         * <p>
         * Only pre-existing <code>WebConfig</code> object properties
         * will be merged, any other will be ignored.
         * </p>
         * 
         * @param o The litteral Object.
         */ 
        public function merge( o:Object ):void
        {
            for( var m:String in o )
            {
                if( hasOwnProperty( m ) )
                {
                    this[m] = o[m];
                }
            }
        }
        
        /**
         * 
         */
        public function toObject():Object
        {
            var obj:Object = {};
            var _class:XML = describeType( this );
            //trace( _class );
            
            var properties:Array = [];
            for each( var member:XML in _class.variable )
            {
                properties.push( member.@name );
            }
            System.disposeXML( _class );
            
            var i:uint;
            var len:uint = properties.length;
            var property:String;
            for( i = 0; i < len; i++ )
            {
                property = properties[i];
                //trace( "[" + i +"]: " + property );
                obj[ property ] = this[ property ];
            }
            
            return obj;
        }
        
    }
}