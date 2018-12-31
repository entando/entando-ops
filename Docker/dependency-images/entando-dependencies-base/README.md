#Entando Core Dependencies

This image provides the most common Entando dependencies in a single image that can be used in multi-stage builds in other images. 
By using the Maven cache provided in $HOME/.m2/, multi stage builds can perform complex Maven builds without having to reload
these core dependencies. Please note that this is not an exhaustive set of Entando dependencies.

This image also hosts a default Derby database that can be contributed to images that need an embedded database for use inside
a JEE container. 
