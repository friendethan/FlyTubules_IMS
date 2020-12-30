# Characterizing Microdissected Fly Tubule Phospholipid IMS Signals
This is an archive for the R codes used to conduct unsupervised statistical analysis for microdissected fly tubule phospholipids as well as fly sections shown in the publication listed below.

## Data Format
The data analyzed are obtained from the Bruker Ultraflex system with flexControl 3.4 and flexImaging 4.0 in the condensed .d format for imaging MS data and fid for MS data.

## Files

* statisticalAnalysis_tubules.R contains the script for pre-processing and statistical analysis of micordissected fly tubules
* visualization_tubules.R contains the script for generating the figures for the microdissected fly tubules
* statisticalAnalysis_sections.R contains the script for pre-processing and statistical analysis of fly sections
* (*In Progress*) visualization_sections.R contains the script for generating the figures for the fly sections 
* functions.R contains functions Ethan Yang used to conduct the necessary analyses for this publication

## Reference Publication
**Yang E**, Gamberi C, Chaurand P. Mapping the fly Malpighian tubule lipidome by imaging mass spectrometry. *J Mass Spectrom. 2019 Jun;54(6):557-566*. [doi:10.1002/jms.4366](https://pubmed.ncbi.nlm.nih.gov/31410898/). PMID: 31038251.

## Contributors 

* Ethan Yang: Wrote 100% of the R codes for exporting and analyzing the IMS data currently available in this repository
* Pierre Chaurand: Provided guidance and outlined the data analysis pipeline; corrected figures

## Dependencies

* [Cardinal](https://github.com/kuwisdelu/Cardinal) for visualizing, statistical analysis as well as exporting results

## Disclaimer
This repository contains only the scripts and functions for analyzing all the imaging mass spectrometry data shown in the publication. In particular, the script was used to conduct the segmentation analysis and for exporting the figures shown. The scripts have been cleaned to represent the final pipeline and have also been scraped to remove any personal identifying information. The session info provided below were determined post publication and therefore may not be an accurate representation of the actual R enviornment during data analysis.   

## License
Please reference the LICENSE document for details. 

## Session Info
R Studio: Version Unknown  
R version 3.4.4 (2018-03-15)  
Platform: x86_64-w64-mingw32/x64 (64-bit)  
Running under: Windows 7 (Build unknown) 

attached base packages:  

* stats
* graphics
* grDevices 
* utils
* datasets  
* methods   
* base     

other attached packages:
* Cardinal_1.2.1

loaded via a namespace (and not attached):
* Rcpp_0.12.16        
* BiocGenerics_0.24.0 
* MASS_7.3-49         
* munsell_0.4.3       
* colorspace_1.3-2    
* lattice_0.20-35     
* R6_2.2.2            
* rlang_0.2.0        
* plyr_1.8.4          
* tools_3.4.4         
* parallel_3.4.4      
* grid_3.4.4          
* Biobase_2.38.0      
* gtable_0.2.0        
* irlba_2.3.2         
* ProtGenerics_1.10.0
* lazyeval_0.2.1      
* yaml_2.1.19         
* mmand_1.5.3         
* tibble_1.4.2        
* Matrix_1.2-12       
* Cardinal_1.2.1      
* signal_0.7-6        
* sp_1.2-7           
* pillar_1.2.1        
* compiler_3.4.4      
* scales_0.5.0        
* XML_3.98-1.10       
* stats4_3.4.4       
