({
	afterRender : function( component, helper ) {

        this.superAfterRender();
        var didScroll = false;

        window.onscroll = function() {
            didScroll = true;
        };

        var scrollCheckIntervalId = setInterval( $A.getCallback( function() {
            if ( didScroll && component.isValid() ) {
                didScroll = false;
                if ( window['scrollY'] >= 10 ) {
                    helper.applyScrollCSS( component );
                }
                else {
                    helper.removeScrollCSS( component );
                }
            }
        }), 10 );

        component.set( 'v.scrollCheckIntervalId', scrollCheckIntervalId );

    }
})