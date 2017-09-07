#!/bin/bash
#===================================================================================
#
#	 FILE:	mdgEntriesSVG.sh
#
#	USAGE:	mdgEntriesSVG.sh
#
# DESCRIPTION:	Used for generating needed LaTeX codes for inclusion of SVGs  into LaTeX
#
#      AUTHOR:	J.L.A. Uro (justineuro@gmail.com)
#     VERSION:	1.0.0
#     LICENSE:	Creative Commons Attribution 4.0 International License (CC-BY)
#     CREATED:	2017.09.07 12:28:29 +8
#    REVISION:	
#==================================================================================

#----------------------------------------------------------------------------------
# input the list of SVG files; create the output filename, backup previous if exists
#----------------------------------------------------------------------------------
echo "List of svg files?"
read svgfiles

filen=$svgfiles.output
if [ -f $filen ]; then
 mv $filen $filen.bak
fi

#----------------------------------------------------------------------------------
# create cat-to-output-file function
#----------------------------------------------------------------------------------
catToFile(){
	cat >> $filen << EOT
$1
EOT
}

#----------------------------------------------------------------------------------
# write entries into output file
#----------------------------------------------------------------------------------
i=0
while read ifile; 
do
	i=`expr $i + 1`
	inkscape -D -z --file=$ifile --export-pdf=${ifile/.svg/}.pdf --export-latex
	echo -e "file $i: converted $ifile to \n\t ${ifile/.svg/}.pdf, \n\t ${ifile/.svg/}.pdf_tex"
	ifileA=${ifile/.svg/}
	ifileB=${ifileA/K516f-/}
	catToFile "\addcontentsline{toc}{subsection}{$ifileB}
\begin{figure}[H]
	\centering
	\def\svgwidth{\columnwidth}
	\input{${ifile/.svg}.pdf_tex}
\end{figure}
\nopagebreak[4]
{\footnotesize For audio (midi): \hyperref{./${ifile/.svg/}.mid}{}{}{${ifile/.svg/}.mid}}
"
done < $svgfiles
###
##
#
