# Prisma Cloud Compute Container Runtime Demo

This demo is designed to showcase the power of Prisma Cloud Compute's container runtime security capabilities. 

## Description

We will deploy a container image that contains a script. If the script is started, it is ready to simulate an "attack", for example a zero day attack in your container environment.

Prisma Cloud can protect against these zero day attacks by automatically building a container runtime model. It understands the default behaviour of the container and is able to alert on or prevent against other behaviour.

If you prepare the demo environment, you start the container in a new namespace to make sure there is a new model.

To speed things up, instead of the automatic building of the model we do this manually for a short time. 

After this is done, you can continously keep running the attacks while enabling or disabling a specific Prisma Cloud rule or modifying the rule to show the capabilities of Prisma Cloud to prevent against these type of attacks without the need to maintain exceptions or a lot of rules.

## Prerequisites

- A Kubernetes cluster
- `kubectl` installed and configured to interact with your cluster
- Prisma Cloud Compute installed and protecting your cluster

## Steps

1. Create a new namespace

    ```kubectl create ns attacker-demo-1```

2. Start the container in your cluster. You can do this by running the following command:

    ```kubectl run pcc-demo --image=ghcr.io/steven-deboer/pcc-demo:main --image-pull-policy=Always -n attacker-demo-1
    ```

3. Next, manually relearn the container runtime model in Prisma Cloud Compute. This step is necessary to create a baseline for normal behavior within the container. 

go to Monitor - Runtime - Container models and find our container image.



3. Once the model has learned enough behavior, stop the manual learning process.

4. In Prisma Cloud Compute, create a runtime rule that alerts on any processes that deviate from the learned model. 

5. Within the container, run the demo script:

    ```shell
    ./pcc_demo.sh
    ```

    Wait for the script to finish running. It will execute several commands that may deviate from the learned model. Because of the runtime rule you created, Prisma Cloud Compute will alert you of these potential threats.

    This demonstrates how the container runtime model works and how it can help protect against zero day attacks with just a single rule. 

6. Now, let's change the effect of the rule from alerting to prevention. This means that any process outside of the model will not only trigger an alert, but also be stopped in its tracks.

![image](https://github.com/steven-deboer/pcc-demo/assets/96180461/2cb33915-d991-42ee-91d3-676d80817aff)

    Save the rule and start the `pcc_demo.sh` script again. This time, Prisma Cloud Compute will not only alert on the potential threats, but also prevent them from being carried out.

Please note that the exact steps to manually learn a model and create a runtime rule might vary based on the version and configuration of your Prisma Cloud Compute installation.


## Screenshots

<img width="710" alt="image" src="https://github.com/steven-deboer/pcc-demo/assets/96180461/e831d1d8-1842-44fd-900e-f5403906dc8d">

<img width="703" alt="image" src="https://github.com/steven-deboer/pcc-demo/assets/96180461/9e37dbfd-de45-4a63-b3ea-1fc3835c1ecf">



