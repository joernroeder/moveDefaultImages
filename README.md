Usage
=====

Select a folder which contains the required files and grab a bounty :)   
The script will move the matched images into the sub-folder (`defaultImageFolder`).

### Required Files

* `_cache.txt`
* `_noImageReference.jpg`


### Variables ###

	String[] referenceImageNames = {
		"_noImageReferenceMale.jpg",
		"_noImageReferenceFemale.jpg"
	};

	String defaultImageFolder = "_defaultImage";

	String cacheFileName = "_cache.txt";


Accuracy in percent of the comparison.

	float accuracy = .01;