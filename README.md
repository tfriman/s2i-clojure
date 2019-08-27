# OpenShift S2I image for building Clojure projects using 'lein uberjar' and Java8.

## Installation to OpenShift 3.11

Login to your OpenShift cluster

```oc login```

You can install this to any namespace but "openshift" is visible to all by default and it is used when service catalog searches for builders so let's use it.

```oc new-build https://github.com/tfriman/s2i-clojure#v1.0.0 --name s2i-clojure -n openshift```

oc new-build https://github.com/tfriman/s2i-clojure#graal-build --name s2i-clojure-graal -n openshift

You can follow the build

```oc logs -f bc/s2i-clojure -n openshift```

## Usage example

Create a test project

```oc new-project clj-test```

After the build has finished you can test your new builder:

```oc new-build s2i-clojure~https://github.com/tfriman/clj-rest-helloworld#v1.0.0 --name=clj-test```

And follow the build

```oc logs -f bc/clj-test```

After the build has finished create a new app:

```oc new-app clj-test```

And open the service to the world:

```oc expose svc/clj-test```

See the url for the application

```oc get routes clj-test --template='{{ .spec.host }}'```

And open it using your browser.

## Making s2i-clojure builder visible to catalog

```oc edit is/s2i-clojure -n openshift -o json```

Make it look like this:

```
{
    "kind": "ImageStream",
    "apiVersion": "v1",
    "metadata": {
	"name": "s2i-clojure-builder",
	"annotations": {
	    "openshift.io/display-name": "S2I Clojure"
	}
    },
    "spec": {
	"tags": [
	    {
		"name": "latest",
		"annotations": {
		    "openshift.io/display-name": "S2I Clojure",
		    "description": "Build and deploy a Clojure app",
		    "iconClass": "icon-clojure",
		    "sampleRepo": "https://github.com/tfriman/clj-rest-helloworld",
		    "sampleRef": "v1.0.0",
		    "tags": "builder,clojure",
		    "version": "latest",
		    "supports": "clojure"
		},
		"from": {
		    "kind": "DockerImage",
		    "name": "s2i-clojure:latest"
		}
	    }
	]
    }
}

```

Wait for a while to catalog service to catch up and your Clojure S2I
builder should appear in the catalog under section "other".