#' @title Add R script into a html object
#'
#' @description Add R script into a \code{"html"} object.
#' 
#' @param doc Object of class \code{"html"} where expressions have to be added
#' @param file R script file. Not used if text is provided.
#' @param text character vector. The text to parse. Not used if file is provided.
#' @param show_line_numbers logical indicating is row numbers should be written or not
#' @param ... further arguments, not used. 
#' @return an object of class \code{"html"}.
#' @examples
#' \dontrun{
#' # Create a new document 
#' doc = html( title = "title" )
#' 
#' # add a page where to add R outputs with title 'page example'
#' doc = addPage( doc, title = "page example" )
#' 
#' doc <- addRScript(doc, text = "ls()" )
#' 
#' # write the html object in a directory
#' pages = writeDoc( doc, "addRScript_example")
#' print( pages ) # print filenames of generated html pages
#' }
#' @seealso \code{\link{html}}, \code{\link{addRScript}}
#' @method addRScript html
#' @S3method addRScript html
addRScript.html = function(doc, file, text, show_line_numbers = T, ... ) {
	
	if( missing( file ) ){
		myexpr = parse( text = text )
	} else {
		myexpr = parse( file = file )
	}

	str = highlight( parse.output = myexpr
		, renderer = renderer_html(document = F, header = NULL, footer = NULL)
		, show_line_numbers = FALSE, output = NULL )
		
	RScript = .jnew(class.html4r.RScript, as.character(paste(str, collapse = "" ) ) )
	out = .jcall( doc$current_slide , "I", "add", RScript )
	if( out != 1 ){
		stop( "Problem while trying to add RScript." )
	}	
	doc
}
