# Let's Learn iOS 11!
### Code Challenge Series #1: CoreML

I'm producing a series of small code challenges that should provide a good introduction to the various new features of iOS 11. This challenge centers around getting started with CoreML. I've included a model that is trained in object identification along with the base project. Your mission is to feed an image into it and display the analysis result to the user. Images can come from any source, with the camera and photo library being the most "realistic" use-cases.

### Setup

*Tools Required:* Xcode 9, iOS 11 device

I've provided a sample project which already has the model imported (nothing special here, just add the .mlmodel file like you would any other file). I've also provided an image helper class which will convert an image into the CVPixelBuffer format required as input by the model.

Here are some resources for getting you started:

* [Introducing CoreML](https://developer.apple.com/videos/play/wwdc2017/703/) — Session 703 from WWDC17.
* [Integrating a CoreML Model Into Your App](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app) — Apple's tutorial on getting started with CoreML.

### Stretch Goals

Looking for an extra challenge? Consider trying to

* **Easy-ish** — Follow [this tutorial](https://medium.com/towards-data-science/introduction-to-core-ml-conversion-tool-d1466bf10018) to convert a Caffe model into a MLModel and use it in your app. *NOTE:* This requires a good deal of faffing about getting an appropriate Python (2.7) environment set up.
* **Moderate** — Use AVFoundation to run the model against live video.
* **Advanced** — Convert an arbitrary model from the [Berkeley Model Zoo](https://github.com/BVLC/caffe/wiki/Model-Zoo) and use it in an app.
* **Master** — Design and train your own machine learning model, publish a paper on arXiv.org about it.

#### Fun Fact

The training data for the squeezenet model  contains a class for hotdogs:

    934: 'hotdog, hot dog, red hot'

Use this information as you see fit.
