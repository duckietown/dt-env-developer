# Running your local AI-DO  

These instructions allow you to run the complete AIDO pipeline on your computer.


## Set up the developer environment
 
See instructions [here](https://github.com/duckietown/dt-env-developer).

In particular you will have set the `DT_ENV_DEVELOPER` variable.


## Download and run the duckietown-challenges-server

See instructions [here](https://github.com/duckietown/duckietown-challenges-server).

Please use branch `v4`.

In particular you will have set the `DTSERVER` variable to point to your local server.
Make sure to do this in every shell that you use.

## Define the challenges

Note: make sure that `DTSERVER` is set before running the following.

This rebuilds all the challenges:

    make define-challenges
   
This makes all test submissions:

    make make-submissions 
    
    
## Run the local evaluator

Note: make sure that `DTSERVER` is set before running the following.

    dts challenges evaluator
    
    
    
