#' @title Create Microsoft PowerPoint document object representation
#'
#' @description
#' Create a \code{"pptx"} object
#' 
#' @param title \code{"character"} value: title of the document (in the doc properties).
#' @param template \code{"character"} value, it represents the filename of the pptx file used as a template.
#' @return an object of class \code{"pptx"}.
#' @details
#' To send R output in a pptx document, a slide (see \code{\link{addSlide.pptx}}
#' have to be added to the object first (because output is beeing written in slides).
#' 
#' Several methods can used to send R output into an object of class \code{"pptx"}.
#' 
#' \itemize{
#'   \item \code{\link{addTitle.pptx}} add titles
#'   \item \code{\link{addParagraph.pptx}} add texts
#'   \item \code{\link{addPlot.pptx}} add plots
#'   \item \code{\link{addTable.pptx}} add tables
#'   \item \code{\link{addFlexTable.docx}} add \code{\link{FlexTable}}
#'   \item \code{\link{addDate.pptx}} add a date (most often in the bottom left area of the slide)
#'   \item \code{\link{addFooter.pptx}} add a comment in the footer (most often in the bottom center area of the slide)
#'   \item \code{\link{addPageNumber.pptx}} add a page number (most often in the bottom right area of the slide)
#'   \item \code{\link{addImage.pptx}} add external images
#' }
#' Once object has content, user can write the pptx into a ".pptx" file, see \code{\link{writeDoc}}.
#' @references Wikipedia: Office Open XML\cr\url{http://en.wikipedia.org/wiki/Office_Open_XML}
#' @note 
#' 
#' Power Point 2007-2013 (*.pptx) file formats are the only supported files.
#' 
#' Document are manipulated in-memory ; a \code{pptx}'s document is not written to the disk 
#' unless the \code{\link{writeDoc}} method has been called on the object.
#' @export
#' @examples
#' #START_TAG_TEST
#' require( ggplot2 )
#' 
#' # PowerPoint document to write
#' pptx.file <- "document_example.pptx"
#' 
#' # set default font to 28pt
#' options("ReporteRs-fontsize" = 28)
#' 
#' # Create a new document
#' doc = pptx( title = "title" )
#' 
#' # display layouts names
#' slide.layouts( doc )
#' 
#' # add a slide with layout "Title Slide"
#' doc = addSlide( doc, slide.layout = "Title Slide" )
#' 
#' doc = addTitle( doc, "Presentation title" ) #set the main title
#' doc = addSubtitle( doc , "This document is generated with ReporteRs.")#set the sub-title
#' 
#' # add a slide with layout "Title and Content" then add content
#' doc = addSlide( doc, slide.layout = "Two Content" )
#' doc = addTitle( doc, "Texts demo" ) #set the main title
#' texts = c( "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
#' , "In sit amet ipsum tellus. Vivamus dignissim arcu sit amet faucibus auctor."
#' , "Quisque dictum tristique ligula."
#' )
#' # add simple text
#' doc = addParagraph( doc, value = texts)
#' 
#' # Add "My tailor is rich" and "Cats and Dogs"
#' # format some of the pieces of text
#' # Add "My tailor is rich" and "Cats and Dogs"
#' # format some of the pieces of text
#' pot1 = pot("My tailor"
#'      , textProperties(color="red") ) + " is " + pot("rich"
#'              , textProperties(font.weight="bold") )
#' pot2 = pot("Cats", textProperties(color="red")
#' ) + " and " + pot("Dogs", textProperties(color="blue") )
#' doc = addParagraph(doc, set_of_paragraphs( pot1, pot2 ) )
#' 
#' 
#' myplot = qplot(Sepal.Length, Petal.Length
#'      , data = iris, color = Species
#'      , size = Petal.Width, alpha = I(0.7)
#' )
#' doc = addSlide( doc, slide.layout = "Title and Content" )
#' 
#' # Add title and then 'myplot' 
#' doc = addTitle( doc, "Plot example" )
#' doc = addPlot( doc, function( ) print( myplot ), pointsize = 11 )
#' 
#' doc = addSlide( doc, slide.layout = "Title and Content" )
#' # Add title and then a sample of iris
#' doc = addTitle( doc, "Table example" )
#' doc = addTable( doc, data = iris[25:33, ] )
#' 
#' # write the doc
#' writeDoc( doc, pptx.file)
#' #STOP_TAG_TEST
#' @seealso \code{\link{addTitle.pptx}}, \code{\link{addImage.pptx}}, \code{\link{addParagraph.pptx}}
#' , \code{\link{addPlot.pptx}}, \code{\link{addTable.pptx}}
#' , \code{\link{slide.layouts.pptx}}, \code{\link{writeDoc.pptx}}

pptx = function( title, template){
	
	# title mngt
	if( missing( title ) ) title = ""
	
	
	# pptx base file mngt
	if( missing( template ) )
		template = paste( find.package("ReporteRs"), "templates/EMPTY_DOC.pptx", sep = "/" )
	.reg = regexpr( paste( "(\\.(?i)(pptx))$", sep = "" ), template )
	
	if( !file.exists( template ) || .reg < 1 )
		stop(template , " is not a valid file.")
	
#	public static int NO_ERROR = 0;
#	public static int READDOC_ERROR = 1;
#	public static int LOADDOC_ERROR = 2;
#	public static int LAYOUT_ERROR = 3;
#	public static int SAVE_ERROR = 4;
#	public static int PARTNAME_ERROR = 5;
#	public static int SLIDECREATION_ERROR = 6;
#	// public static int slidedimensions_error = 7;
#	public static int UNDEFINED_ERROR = -1;
	# java calls
	obj = .jnew( class.pptx4r.document )
	
	basedoc.return = .jcall( obj, "I", "setBaseDocument", template )
	if( basedoc.return != error_codes["NO_ERROR"] ){
		stop( "an error occured - code[", names(error_codes)[which( error_codes == basedoc.return )], "].")
	}
	
	.Object = list( obj = obj
		, title = title
		, basefile = template
		, styles = .jcall( obj, "[S", "getStyleNames" ) 
		, plot_first_id = 0L
		, current_slide = NULL
		)
	class( .Object ) = "pptx"
	
	.Object
}

