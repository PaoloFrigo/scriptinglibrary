:: MD CONVERT
:: ------------------------
:: Converts all MarkDowns files passed as arguments into different 
:: formats and saves them into a separate folder.
::
:: AUTHOR:   Paolo Frigo    https://www.scriptinglibrary.com
::
:: REQUIREMENTS:    
::      pandoc (https://pandoc.org/)
::      miktex for pdf conversion form LaTeX (https://miktex.org/)
set list=docx html rst odt rtf epub pdf

for %%x in (%*) do (
    mkdir output   
    mkdir output\\%%~nx
    for %%e in (%list%) do ( 
        mkdir output\\_%%e 
        pandoc %%x -o output/_%%e/%%~nx.%%e
        pandoc %%x -o output/%%~nx/%%~nx.%%e
    )
    :: Keep a copy of the MarkDown File. 
    mkdir output\\_md
    copy %%x output\_md\
    copy %%x output\%%~nx\
)
