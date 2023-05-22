# Prisma Cloud Compute Container Runtime Demo with BusyBox

This demo is designed to showcase the power of Prisma Cloud Compute's container runtime security capabilities. 

## Prerequisites

- A Kubernetes cluster
- `kubectl` installed and configured to interact with your cluster
- Prisma Cloud Compute installed and protecting your cluster

## Steps

1. Start a BusyBox container in your cluster. You can do this by running the following command:

    ```shell
    kubectl run -i --tty busybox-demo --image=busybox --restart=Never -- sleep infinity
    ```

2. Next, manually relearn the container runtime model in Prisma Cloud Compute. This step is necessary to create a baseline for normal behavior within the container. 

    During the relearn phase, make sure to execute the commands `clear` and `date` in the container, so that these commands are part of the learned model.

3. Once the model has learned enough behavior, stop the manual learning process.

4. In Prisma Cloud Compute, create a runtime rule that alerts on any processes that deviate from the learned model. 

5. Within the BusyBox container, create a new file named `security_checks.sh`. This will be the script that checks for potential security threats. Make the script executable with the following command:

    ```shell
    chmod +x security_checks.sh
    ```

6. Run the security check script:

    ```shell
    ./security_checks.sh
    ```

    Wait for the script to finish running. It will execute several commands that may deviate from the learned model. Because of the runtime rule you created, Prisma Cloud Compute will alert you of these potential threats.

    This demonstrates how the container runtime model works and how it can help protect against zero day attacks with just a single rule. 

7. Now, let's change the effect of the rule from alerting to prevention. This means that any process outside of the model will not only trigger an alert, but also be stopped in its tracks.

![image](https://github.com/steven-deboer/pcc-demo/assets/96180461/2cb33915-d991-42ee-91d3-676d80817aff)

    Save the rule and start the `security_checks.sh` script again. This time, Prisma Cloud Compute will not only alert on the potential threats, but also prevent them from being carried out.

Please note that the exact steps to manually learn a model and create a runtime rule might vary based on the version and configuration of your Prisma Cloud Compute installation.


## Screenshots

<img width="710" alt="image" src="https://github.com/steven-deboer/pcc-demo/assets/96180461/e831d1d8-1842-44fd-900e-f5403906dc8d">

<img width="703" alt="image" src="https://github.com/steven-deboer/pcc-demo/assets/96180461/9e37dbfd-de45-4a63-b3ea-1fc3835c1ecf">



