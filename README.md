# OpenShift S2I image for building Clojure projects using 'lein uberjar' and Java8.

## Installation to OpenShift

Login to your OpenShift cluster

```oc login```

You can install this to any namespace but "openshift" is visible to all. If you are using some other namespace than "openshift" make sure that namespace is visible to your projects.

```oc new-build https://github.com/tfriman/s2i-clojure --name s2i-clojure -n namespacex```

After the build has finished you can test your new builder:

```oc new-build namespacex/s2i-clojure~https://bitbucket.org/tfriman/clj-rest-helloworld --name=clj-test```

After the build has finished create a new app:

```oc new-app clj-test```

And open the service to the world:

```oc expose svc/clj-test```

See the url for the application

```oc get routes```

And open it using your browser.

### Making s2i-clojure builder visible to catalog

```oc edit is/s2i-clojure -n namespacex -o json```

Make it look like this:

```
{
    "kind": "ImageStream",
    "apiVersion": "v1",
    "metadata": {
	"name": "s2i-clojure-buildr",
	"annotations": {
	    "openshift.io/display-name": "S2I Clojure"
	}
    },
    "spec": {
	"tags": [
	    {
		"name": "latest",
		"annotations": {
		    "openshift.io/display-name": "S2I Clojure xxx",
		    "description": "Build and deploy a Clojure app",
		    "iconClass": "icon-clojure",
		    "sampleRepo": "https://bitbucket.org/tfriman/clj-rest-helloworld",
		    "tags": "builder,clojure",
		    "version": "latest"
		},
		"from": {
		    "kind": "DockerImage",
		    "name": "namespacex/s2i-clojure:latest"
		}
	    }
	]
    }
}

```