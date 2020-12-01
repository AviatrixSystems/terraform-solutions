Aviatrix kickstart BackEnd
===========

this is the repo for aviatrix kickstart api's built using flask restful. 

Requirements
------------

- Flask (`pip install flask`).
- Flask-RESTful (`pip install Flask-RESTful`).


Installation
------------

You can create a virtual environment and install the required packages with the following commands:

    $ virtualenv venv
    $ . venv/bin/activate
    (venv) $ pip install -r requirements.txt

Running  backend using Docker
--------------------

Instructions
------------
Install Docker if you don't already have it: https://docs.docker.com/get-docker/.

Build the image:
```docker build -t aviatrix-kickstart --file Dockerfile_kickstart_web .```

Start the container:
```
docker volume create TF
docker run -v TF:/root -p 5000:5000 -d aviatrix-kickstart
```

Launch Aviatrix Kickstart by navigating to http://0.0.0.0:5000/


