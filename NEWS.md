# textfeatures 0.2.0

# textfeatures 0.1.4

* `textfeatures()` now returns word2vec dimension estimates 
* New `sentiment` and `word2vec_dims` arguments allow users to customize (and
speed up) feature extraction process
* Added `normalize` argument, which by default preprocesses feature values
* Various bug fixes and improvements
* `scale_*` functions more robust

# textfeatures 0.1.3

* Functions now return "id" or (the first variable ending with (.|_)id)
* Returns numeric and integer columns to allow scaling flexibility
* Now exports several scale-transformation convenience functions
* Added sentiment and politeness text analysis
* Now allows use of `textfeatures()` method only without the substantive 
analysis (sentiment)

# textfeatures 0.1.2

* Added sentiment and politness variables
* Returns all numeric columns and natural logs all counting variables
* No longer exports redundant grouped_df version
* Various bug fixes and speed improvements

# textfeatures 0.1.1

* Added small executable examples to documentation.

# textfeatures 0.1.0

* Initial package launch.
* Added a `NEWS.md` file to track changes to the package.
